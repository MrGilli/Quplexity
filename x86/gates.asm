section .data
  sqrt2_inv dq 0.7071067811865475  ; 1/sqrt(2)
  one dq 1.0
  neg_one dq -1.0

section .bss
  n1 resq 1
  n2 resq 1

section .text
  global _H

_H:
  ; Load input vector elements
  MOVSD XMM0, [RDI]       ; First element
  MOVSD XMM1, [RDI + 8]   ; Second element

  ; Load constants using RIP-relative addressing
  MOVSD XMM2, [rip + one]
  MOVSD XMM3, [rip + neg_one]
  MOVSD XMM4, [rip + sqrt2_inv]

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

  ; Store results
  MOVSD [RDI + 8], XMM0
  MOVSD XMM0, [n1]
  MOVSD [RDI], XMM0

  RET
