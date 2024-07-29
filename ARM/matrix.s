// © Jacob Liam Gill 2024. **DO NOT REMOVE THIS LINE.**
// Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

// I'm striving to make the code for Quplexity as readable as possible.
// If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
// Or DM/friend request me on Discord: @mrgill0651


.global _gills_inv_matrix2x2
.global _gills_matrix2x2
.global _gills_matrix2x1
.align 3

_gills_inv_matrix2x2:
    // Load input numbers into D registers
    LDR  D0,  [X0]     // D0 = num1
    LDR  D1,  [X1]     // D1 = num2
    LDR  D2,  [X2]     // D2 = num3
    LDR  D3,  [X3]     // D3 = num4
    FMOV D12, #1.0     // for 1/det(A)

    // Calculate determinant = num1*num4 - num2*num3
    FMUL D4, D0, D3  // D4 = num1 * num4
    FMUL D5, D1, D2  // D5 = num2 * num3
    FSUB D6, D4, D5  // D6 = num1*num4 - num2*num3 (determinant)

    // Compare determinant with zero
    FCMP D6, #0.0
    B.EQ _determinant_zero

    // Calculate the inverse determinant
    FDIV D7, D12, D6 // D7 = 1 / determinant

    // Calculate inverse matrix elements
    FMUL D8,  D3, D7    // D8 = num4 / determinant
    FMUL D9,  D1, D7    // D9 = -num2 / determinant
    FMUL D10, D2, D7    // D10 = -num3 / determinant
    FMUL D11, D0, D7    // D11 = num1 / determinant

    // Store results in out_matrix
    STR  D8,  [X4, #0]  // out_matrix[0] = D8
    FNEG D9,  D9        // D9 is now negative
    STR  D9,  [X4, #8]  // out_matrix[1] = D9
    FNEG D10, D10       // D10 is now negative
    STR  D10, [X4, #16] // out_matrix[2] = D10
    STR  D11, [X4, #24] // out_matrix[3] = D11

    RET

_determinant_zero:
    // Set out_matrix to zero if determinant is zero

    RET

_gills_matrix2x2:
    // Load elements of matrixA into d registers
    LDR D0, [X0]            // matrixA[0][0]
    LDR D1, [X0, #8]        // matrixA[0][1]
    LDR D2, [X0, #16]       // matrixA[1][0]
    LDR D3, [X0, #24]       // matrixA[1][1]

    // Load elements of matrixB into d registers
    LDR D4, [X1]            // matrixB[0][0]
    LDR D5, [X1, #8]        // matrixB[0][1]
    LDR D6, [X1, #16]       // matrixB[1][0]
    LDR D7, [X1, #24]       // matrixB[1][1]

    FMUL D8, D0, D4         // a1a2
    FMUL D9, D1, D6         // b1c2
    FADD D8, D8, D9         // a1a2 + b1c2

    FMUL D9,  D0, D5        // a1b2
    FMUL D10, D1, D7        // b1d2
    FADD D9,  D9, D10       // a1b2 + b1d2

    FMUL D10, D2, D4        // c1a2
    FMUL D11, D3, D6        // d1c2
    FADD D10, D10, D11      // c1a2 +  d1c2

    FMUL D11, D2, D5        // c1b2
    FMUL D12, D3, D7        // d1d2
    FADD D11, D11, D12      // c1b2 + d1d2

    STR D8,  [X2, #0]
    STR D9,  [X2, #8]
    STR D10, [X2, #16]
    STR D11, [X2, #24]

    RET

_gills_matrix2x1:
    // LOAD 2x1 MATRIX VALUES (DOUBLE)
    LDR  D0, [X0, #0]   // A1
    LDR  D1, [X1, #0]   // A2
    LDR  D2, [X0, #8]   // B1
    LDR  D3, [X1, #8]   // B2

    FMUL D0, D0, D1
    FMUL D2, D2, D3
    FADD D0, D0, D2

    STR  D0, [X2]
    RET
