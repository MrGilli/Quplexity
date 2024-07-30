// © Jacob Liam Gill 2024. **DO NOT REMOVE THIS LINE.**
// Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

// I'm striving to make the code for Quplexity as readable as possible.
// If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
// Or DM/friend request me on Discord: @mrgill0651

.global _pauli_X
.global _pauli_Z
.global _gills_hadamard2x1
.global _gills_hadamard2x2
.align 3
neg_one: .float -1.0

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

//_pauli_Y not done yet!!
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
    
_gills_hadamard2x2:
    LDR D1, [X0]
    LDR D2, [X0, #8]
    LDR D3, [X0, #16]
    LDR D4, [X0, #24]

    // [H] = 1/sqrt(2)
    FMOV D5, #1.0
    FMOV D6, #2.0
    FSQRT D7, D6
    FDIV D0, D5, D7

    // Multiply each element of the 2x2 matrix by D0
    FMUL D1, D1, D0
    FMUL D2, D2, D0
    FMUL D3, D3, D0
    FMUL D4, D4, D0

    STR D1, [X1, #0]
    STR D2, [X1, #8]
    STR D3, [X1, #16]
    STR D4, [X1, #24]

    // Return output 2x2 Matrix to caller.
    RET 
