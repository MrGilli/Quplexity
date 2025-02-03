; © Jacob Liam Gill 2025. All rights reserved. **DO NOT REMOVE THIS LINE.**
; Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

; I'm striving to make the code for Quplexity as readable as possible.
; If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
; Or DM/friend request me on Discord: @mrgill0651


section .data
  sqrt2_inv dq 0.7071067811865475  ; 1/sqrt(2)
  one dq 1.0
  zero dq 0.0
  neg_one dq -1.0
  two dq 2.0
  threshold dq 0.5

section .bss
  n1 resq 1
  n2 resq 1

section .text
  global _PX
  global _PZ
  global _H
  global _CNOT
  global _CCNOT
  global _CZ

_PX:
  ; Pauli-X Quantum Gate
  ; Load input vector elements
  MOVSD XMM0, [RDI]       ; First element (qubit[0])
  MOVSD XMM1, [RDI + 8]   ; Second element (qubit[1])

  ; Perform Pauli-X operation (swapping elements)
  ; qubit[0] = qubit[1], qubit[1] = qubit[0]
  MOVSD XMM2, XMM1        ; Store qubit[1] into XMM2
  MOVSD XMM1, XMM0        ; Store qubit[0] into XMM1
  MOVSD [RDI], XMM2       ; Store XMM2 (old qubit[1]) into qubit[0]
  MOVSD [RDI + 8], XMM1   ; Store XMM1 (old qubit[0]) into qubit[1]

  RET

_PZ:
  ; Pauli-Z Quantum Gate
  ; Load input vector elements
  MOVSD XMM0, [RDI]      ; Load the first element (a) into XMM0
  MOVSD XMM1, [RDI + 8]  ; Load the second element (b) into XMM1

  ; Pauli-Z matrix elements
  ; [ 1.0,  0.0 ] * [ a ]
  ; [ 0.0, -1.0 ] * [ b ]

  MOVSD XMM2, QWORD [one]  
  MOVSD XMM3, QWORD [zero] 

  ; Row 1 
  MULSD XMM2, XMM0  
  MOVSD [RDI], XMM2

  ; Row 2
  MOVSD XMM3, QWORD [neg_one]
  MULSD XMM3, XMM1 

  MOVSD [RDI + 8], XMM3

  RET

_H:
  ; Load input vector elements
  MOVSD XMM0, [RDI]       ; First element
  MOVSD XMM1, [RDI + 8]   ; Second element

  MOVSD XMM2, QWORD [one]
  MOVSD XMM3, QWORD [neg_one]
  MOVSD XMM4, QWORD [sqrt2_inv]

  ; Perform the Hadamard transformation
  ; Row 1
  MULSD XMM0, XMM2
  MULSD XMM1, XMM2
  ADDSD XMM0, XMM1          ; XMM0 = x1 + x2

  MULSD XMM0, XMM4          ; XMM0 *= 1/sqrt(2)
  MOVSD [n1], XMM0

  ; Row 2
  MOVSD XMM0, [RDI]         ; Reload the first element into XMM0
  MOVSD XMM1, [RDI + 8]     ; Reload second element
  MULSD XMM0, XMM2
  MULSD XMM1, XMM3
  ADDSD XMM0, XMM1
  MULSD XMM0, XMM4

  ;Store results
  MOVSD [RDI + 8], XMM0
  MOVSD XMM0, [n1]
  MOVSD [RDI], XMM0

  RET


_CNOT:
  ;Fist Qubit (control)
  MOVSD XMM0, [RDI]
  MOVSD XMM1, [RDI + 8]

  ;Second Qubit (Target)
  MOVSD XMM2, [RSI]
  MOVSD XMM3, [RSI + 8]

  MOVSD XMM4, QWORD [two]
  MOVSD XMM5, QWORD [zero]

  DIVSD XMM0, XMM4
  UCOMISS XMM0, XMM5

  JP ZERO 

  ; If control qubit is non-zero, apply Pauli-X
  
  MOVSD XMM4, XMM2           
  MOVSD XMM2, XMM3           
  MOVSD XMM3, XMM4           

  ; Store the updated values back to the target qubit memory
  MOVSD [RSI], XMM2
  MOVSD [RSI + 8], XMM3

  RET

_CCNOT:
  ; Load qubit 1 (control qubit 1)
  MOVSD XMM1, [RDI + 8]    ; Load second element of qubit 1 into XMM1 (check if |1⟩)

  ; Load qubit 2 (control qubit 2)
  MOVSD XMM3, [RSI + 8]    ; Load second element of qubit 2 into XMM3 (check if |1⟩)

  ; Load qubit 3 (target qubit)
  MOVSD XMM5, [RDX]        ; Load first element of qubit 3 into XMM5
  MOVSD XMM6, [RDX + 8]    ; Load second element of qubit 3 into XMM6

  ; Constants for qubit checking
  MOVSD XMM7, [one]       ; Load constant 1.0

  ; Check if second element of qubit 1 (control qubit 1) is 1.0 (|1⟩ state)
  UCOMISD XMM1, XMM7       ; Compare qubit 1's second element with 1.0
  JNE ZERO                 ; Jump to ZERO if qubit 1 is not in |1⟩ state

  ; Check if second element of qubit 2 (control qubit 2) is 1.0 (|1⟩ state)
  UCOMISD XMM3, XMM7       ; Compare qubit 2's second element with 1.0
  JNE ZERO                 ; Jump to ZERO if qubit 2 is not in |1⟩ state

  ; Both control qubits are in |1⟩ state, apply Pauli-X (flip) to qubit 3

  ; Pauli-X gate: swap the values of qubit 3 (target qubit)
  MOVSD XMM7, XMM5         ; Temporarily store first element of qubit 3 in XMM7
  MOVSD XMM5, XMM6         ; Move second element into the first element's place
  MOVSD XMM6, XMM7         ; Move the original first element into the second element's place

  ; Store the flipped values back to the target qubit memory
  MOVSD [RDX], XMM5        ; Store flipped first element of qubit 3
  MOVSD [RDX + 8], XMM6    ; Store flipped second element of qubit 3

  RET

_CZ:
  MOVSD XMM0, [RDI]
  MOVSD XMM1, [zero]

  UCOMISD XMM0, XMM1
  JNE ZERO

  MOVSD XMM0, [RSI]
  MOVSD XMM1, [RSI + 8]

  ; Apply Pauli-Z
  ; Pauli-Z matrix elements
  ; [ 1.0,  0.0 ] * [ a ]
  ; [ 0.0, -1.0 ] * [ b ]

  MOVSD XMM2, QWORD [one]  
  MOVSD XMM3, QWORD [zero] 

  ; Row 1 
  MULSD XMM2, XMM0  
  MOVSD [RSI], XMM2

  ; Row 2
  MOVSD XMM3, QWORD [neg_one]
  MULSD XMM3, XMM1 

  MOVSD [RSI + 8], XMM3

  RET


ZERO:
  ; No change to target qubit if control qubits are not both in |1⟩ state
  RET
