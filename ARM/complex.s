.global _define_imaginary
.align 3

.double -1.0

_define_imaginary:
    MOV W1, #0x43       // W1 = ASCII for '+'

    MOV w2, #0x2D       // Load ASCII value of '-' (0x2D) into w2
    STRB w2, [x0]       // Store byte from w2 into the address pointed by x0

    MOV w2, #0x69       // Load ASCII value of 'i' (0x69) into w2
    STRB w2, [x0, #1]   // Store byte from w2 into the address pointed by x0 + 1

    RET

