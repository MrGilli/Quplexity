// © Jacob Liam Gill 2024. All rights reserved. **DO NOT REMOVE THIS LINE.**
// Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

// I'm striving to make the code for Quplexity as readable as possible.
// If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
// Or DM/friend request me on Discord: @mrgill0651

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

    //ROW 1
    //0⋅α + -i⋅β
    MUL W6, W2, W4
    MUL W7, W3, W5
    ADD W7, W7, W6
    //IF NOT 0 OR NEGATIVE = -i

    //ROW 2
    //(i)⋅α + 0⋅β
    MUL W8, W1, W4
    MUL W9, W2, W5
    ADD W9, W9, W8
