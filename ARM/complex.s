.global _define_imaginary
.align 3

.double -1.0

_define_imaginary:
    MOV W1, #0x43       // W1 = ASCII for '+'

    MOV w2, #0x2D       // Load ASCII value of '-' (0x2D) into w2
    STRB w2, [x0]       // Store byte from w2 into the address pointed by x0

    MOV w2, #0x69       // Load ASCII value of 'i' (0x69) into w2
    STRB w2, [x0, #1]   // Store byte from w2 into the address pointed by x0 + 1

    MOV w2, #0          // Load null terminator (0x00) into w2
    STRB w2, [x0, #2]   // Store null terminator into the address pointed by x0 + 2

    RET

_pauli_Y:
    // (0⋅α + -i⋅β 
    //  (i)⋅α + 0⋅β​)=(α−β​)
    // Y = (0 -i 
    //      ​i 0​)
    MOV W1, #1
    MOV W2, #0
    MOV W3, -1

    LDR W4, [X0, #0]
    LDR W5, [X0, #8]
    
    //NOT FINISHED
    RET
