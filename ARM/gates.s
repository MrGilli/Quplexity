// © Jacob Liam Gill 2024. All rights reserved. **DO NOT REMOVE THIS LINE.**
// Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

// I'm striving to make the code for Quplexity as readable as possible.
// If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
// Or DM/friend request me on Discord: @mrgill0651

.global _pauli_X
.global _pauli_Z
.global _identity_matrix2x2
.global _hadamard
.align 3

_pauli_X:
    // Define pauli_X gate:
    // [0.0, 1.0]
    // [1.0, 0.0]
    FMOV D1, #0.0
    FMOV D2, #1.0

    //Load supplied state vector values:
    // e.g: [0]
    //      [1]

    LDR D5, [X0, #0]
    LDR D6, [X0, #8]

    //Apply pauli_X given a state vector full of types: doubles/floats
    //∣ψ′⟩=X∣ψ⟩=(01​10​)(αβ​)=(βα​)
    //(0⋅α + 1⋅β 
    //1⋅α + 0⋅β​)=(βα​)

    //ROW 1
    FMUL D7, D1, D5     //D7 = 0 * a
    FMUL D8, D2, D6     //D8 = 1 * b
    FADD D9, D7, D8     //D9 = D7 + D8
    //ROW 2
    FMUL D10, D2, D5    //D10 = 1 * a
    FMUL D11, D1, D6    //D11 = 0 * b
    FADD D12, D11, D10  //D12 = D11 + D10

    //Output the new state of the qubit after 
    //the Pauli-X gate has been applied
    STR D9, [X1, #0]    //D9 = Output matrix [0]
    STR D12, [X1, #8]   //D12 = Output matrix [1]

    RET                 //Return to caller

//_pauli_Y:
    // Y = (0 -i ​i 0​)
    // Define pauli_Y gate
    //FMOV D1, #0.0
    //FMOV D2, #1.0

    //LDR D3, [X0, #0]    // = a
    //LDR D4, [X0, #8]    // = b

    // (0⋅α + -i⋅β 
    //  (i)⋅α + 0⋅β​)=(α−β​)
    // ROW 1
    //FMUL D5, D1, D2
    //FMUL D6, D2, D4
    //FADD D7, D5, D6
    //VCMPE.D64 D7, D1      // Compare double-precision floating-point values in D7 and D1
    //VMRS APSR_nzcv, FPSCR // Move the result of the comparison to APSR (Application Program Status Register)


_pauli_Z:
    //Define pauli_X gate:
    // [1.0,  0.0]
    // [0.0, -1.0]
    FMOV D1, #1.0   // D1 = 1.0
    FMOV D2, #0.0   // D2 = 0.0
    // -1.0
    FMOV D3, #1.0   // D3 = -1.0
    FNEG D3, D3

    // Load vector numbers:
    LDR D5, [X0, #0] // = a
    LDR D6, [X0, #8] // = b

    // (1⋅α + 0⋅β 
    //  0⋅α + (−1)⋅β​)=(α−β​)
    // ROW 1:
    FMUL D7, D1, D5 //D7 = 1.0 * 0 = 0
    FMUL D8, D2, D6 //D8 = 0.0 * 1.0 = 0
    FADD D9, D7, D8 //D7 = 0 + 0 = 0

    //ROW 2:
    FMUL D10, D2, D5 //D8 = 0.0 * 0.0 = 0
    FMUL D11, D3, D6 //D9 = -1 * 1 = -1
    FADD D12, D10, D11 //D10 = 0 + (-1) = -1

    STR D9, [X1, #0] // 0
    STR D12, [X1, #8] // 0

    RET                 // Return to caller.

_identity_matrix2x2:
    // I=(1 0 ​0 1​)
    //(a×1 + b×0, ​a×0 + b×1)
    //(c×1 + d×0, c×0 + d×1​)
    FMOV D1, #0.0
    FMOV D2, #1.0
    
    //Load Matrix(A) values
    LDR D3, [X0]
    LDR D4, [X0, #8]
    LDR D5, [X0, #16]
    LDR D6, [X0, #24]

    //ROW 1
    //(a×1 + b×0, ​a×0 + b×1)
    FMUL D7, D2, D3
    FMUL D8, D1, D4
    FADD D9, D8, D7
    
    FMUL D10, D3, D1
    FMUL D11, D4, D2
    FADD D12, D11, D10

    //ROW 2
    //(c×1 + d×0, c×0 + d×1​)
    FMUL D13, D5, D2
    FMUL D14, D6, D1
    FADD D15, D14, D13

    FMUL D16, D5, D1
    FMUL D17, D6, D2
    FADD D18, D17, D16

    STR D9,  [X1, #0]
    STR D12, [X1, #8]
    STR D15, [X1, #16]
    STR D18, [X1, #24]

    RET

_hadamard:
    LDR D1, [X0]
    LDR D2, [X0, #8]

    FMOV D3, #1
    FMOV D4, -1
    
    //2x2 x Qubit:
    //Row 1:
    FMUL D5, D3, D1
    FMUL D6, D3, D2
    FADD D5, D5, D6

    //Row 2:
    FMUL D6, D3, D1
    FMUL D7, D4, D2
    FADD D6, D6, D7

    // [H] = 1/sqrt(2)
    FMOV D7, #2.0
    FSQRT D8, D7
    FDIV D0, D3, D8

    // Multiply each element of the 2x2 matrix by D0
    FMUL D5, D0, D5
    FMUL D6, D0, D6

    STR D5, [X1, #0]
    STR D6, [X1, #8]
    
    RET 
