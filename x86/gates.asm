; © Jacob Liam Gill 2025. All rights reserved. **DO NOT REMOVE THIS LINE.**
; Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

; I'm striving to make the code for Quplexity as readable as possible.
; If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
; Or DM/friend request me on Discord: @bixel0

section .data
  align 16
  sqrt2_inv dq 0.7071067811865475, 0.7071067811865475  ; 1/sqrt(2)
  align 16
  one_state dq 0.0, 1.0
  align 16 
  const dq 1.0, -1.0   ; For Pauli-Z and controlled-Z gates (flip the second component)
  align 16
  neg_imag dq 0.0, -1.0, 1.0, 0.0   ; For multiplying by -i and i in Pauli-Y gate
  one dq 1.0
  zero dq 0.0

section .text
  global _QuantumCircuit
  global _PX
  global _PZ
  global _PY
  global _H
  global _H_basic
  global _CNOT
  global _CCNOT
  global _CZ


_QuantumCircuit:
  xor rdx, rdx                  ; rdx = loop counter (qubit index)
  shl rdi, 5                    ; rdi = num_of_qubits * 32 (each qubit is 4 doubles = 32 bytes)

  movq xmm0, qword [one]        ; Load 1.0 into xmm0 (a_real)
  movq xmm1, qword [zero]       ; Load 0.0 into xmm1 (a_imag)
  movq xmm2, qword [zero]       ; Load 0.0 into xmm2 (b_real)
  movq xmm3, qword [zero]       ; Load 0.0 into xmm3 (b_imag)

init_loop:
  cmp rdx, rdi                  ; Compare index with end
  jge done                      ; If rdx >= num_of_qubits * 32, exit

  lea rax, [rsi + rdx]          ; rax = qubits + rdx
  movaps [rax], xmm0            ; Store (1.0, 0.0)
  movaps [rax + 16], xmm2       ; Store (0.0, 0.0)

  add rdx, 32                   ; Move to next qubit (4 doubles = 32 bytes)
  jmp init_loop                 ; Repeat

done:
  ret

_PX:
  ; Pauli-X Quantum Gate
  MOVAPD XMM0, [RDI]            ; Load qubit
  SHUFPD XMM0, XMM0, 01b        ; Swap qubit[0] and qubit[1]
  MOVAPD [RDI], XMM0            ; Store the swapped qubit back
  RET

_PZ:
  ; Pauli-Z Quantum Gate
  MOVAPD XMM0, [RDI]            ; Load qubit
  MULPD XMM0, [const]           ; Apply Pauli-Z gate (flip the phase of qubit[1])
  MOVAPD [RDI], XMM0            ; Store result back to qubit
  RET

_PY:
  ; Pauli-Y Quantum Gate
  MOVAPD XMM0, [RDI]            ; Load qubit
  MOVAPD XMM1, [RDI + 16]       ; Get second part of the qubit
  SHUFPD XMM2, XMM1, 01b        ; Flip to work on the imaginary part
  MULPD XMM2, [neg_imag]        ; Multiply by -i
  SHUFPD XMM3, XMM0, 01b        ; Flip real to imaginary part
  MULPD XMM3, [neg_imag]        ; Multiply by i
  MOVAPD [RDI], XMM2            ; Store the real part
  MOVAPD [RDI + 16], XMM3       ; Store the imaginary part
  RET

_H:
  SHL RDI, 5                    ; rdi = qubit_index * 32 (offset in bytes)
  ADD RDI, RSI                  ; rdi = address of target qubit (qubits + offset)

  MOVQ XMM0, qword [rdi]        ; Load a_real
  MOVQ XMM1, qword [rdi+8]      ; Load a_imag
  MOVQ XMM2, qword [rdi+16]     ; Load b_real
  MOVQ XMM3, qword [rdi+24]     ; Load b_imag

  ADDPD XMM0, XMM2              ; (a_real + b_real), (a_imag + b_imag)
  ADDPD XMM2, XMM0              ; (a_real - b_real), (a_imag - b_imag)

  MOVQ XMM4, qword [sqrt2_inv]
  MULPD XMM0, XMM4           
  MULPD XMM2, XMM4           

  MOVQ qword [rdi], XMM0        ; Store updated 
  MOVQ qword [rdi+8], XMM1   
  MOVQ qword [rdi+16], XMM2  
  MOVQ qword [rdi+24], XMM3

  RET

_H_basic:
  ; Basic Hadamard gate: applies the Hadamard operation on the input qubit
  MOVAPD XMM0, [RDI]            ; Load qubit (q[0], q[1])
  MOVAPD XMM1, XMM0
  MULPD XMM1, [const]           ; XMM1 = [q[0], -q[1]]
  HADDPD XMM0, XMM1             ; XMM0 = [q[0] + q[1], q[0] - q[1]]
  MULPD XMM0, [sqrt2_inv]       ; Scale by 1/sqrt(2)
  MOVAPD [RDI], XMM0            ; Store back to qubit
  RET

_CNOT:
  SHL RDI, 5                    ; rdi = control_index * 32 (offset in bytes)
  ADD RDI, RDX                  ; rdi = address of control qubit (qubits + offset)

  MOVAPD XMM0, [RDI]            ; control qubit (ca[0], cb[1])
  ;MOVAPD XMM1, [RDI + 16]      ; target qubit (ta[0], tb[1])


  UCOMISS XMM0, [one_state]     ; compare control qubit 1 with |1>
  JE retcn

  SHL RSI, 5                    ; rdi = control_index * 32 (offset in bytes)
  ADD RSI, RDX                  ; rdi = address of control qubit (qubits + offset)
 

  MOVQ XMM0, qword [RDI]        ; Load a_real
  MOVQ XMM1, qword [RDI+8]      ; Load a_imag
  MOVQ XMM2, qword [RDI+16]     ; Load b_real
  MOVQ XMM3, qword [RDI+24]     ; Load b_imag      
  

  MOVQ qword [RSI], XMM0        ; Store updated 
  MOVQ qword [RSI+8], XMM1   
  MOVQ qword [RSI+16], XMM2  
  MOVQ qword [RSI+24], XMM3

retcn: RET



_CCNOT:
  ; Controlled-Controlled-NOT Gate (Toffoli gate)
  MOVAPD XMM0, [RDI]            ; Load control qubit 1
  CMPPD XMM0, [one_state], 0    ; Compare control qubit 1 with |1>
  PTEST XMM0, XMM0              ; Test if zero
  JZ retcc                      ; If not |1>, return

  MOVAPD XMM0, [RSI]            ; Load control qubit 2
  CMPPD XMM0, [one_state], 0    ; Compare control qubit 2 with |1>
  PTEST XMM0, XMM0              ; Test if zero
  JZ retcc                      ; If not |1>, return

  MOVAPD XMM0, [RDX]            ; Load target qubit
  SHUFPD XMM0, XMM0, 01b        ; Swap target qubit
  MOVAPD [RDX], XMM0            ; Store flipped target qubit back
retcc:
  RET

_CZ:
  ; Controlled-Z Gate
  MOVAPD XMM0, [RDI]            ; Load control qubit
  CMPPD XMM0, [one_state], 0    ; Compare control qubit with |1>
  PTEST XMM0, XMM0              ; Test if zero
  JZ retz                       ; If not |1>, return

  MOVAPD XMM0, [RSI]            ; Load target qubit
  MULPD XMM0, [const]           ; Apply Pauli-Z gate (flip the phase of qubit[1])
  MOVAPD [RSI], XMM0            ; Store updated target qubit back
retz:
  RET

ZERO:
  ; No change to target qubit if control qubits are not both in |1⟩ state
  RET
