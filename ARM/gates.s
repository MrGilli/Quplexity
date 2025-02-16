// © Jacob Liam Gill 2025. All rights reserved. **DO NOT REMOVE THIS LINE.**
// Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

// I'm striving to make the code for Quplexity as readable as possible.
// If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
// Or DM/friend request me on Discord: @mrgill0651

.global _PX
.global _PZ
.global _IM2x2
.global _H
.global _CNOT
.global _CCNOT
.global _CZ
.global _SWAP
.global _FREDKIN
.global _CP
.align 3

sqrt2_inv:
    .double 0.7071067811865475


_PX:
    FMOV D1, #0.0           // D1 = 0.0; PX matrix number
    FMOV D2, #1.0           // D2 = 1.0; PX matrix number


    LDR D5, [X0, #0]        // D5 = qubit vector 1;
    LDR D6, [X0, #8]        // D6 = qubit vector 2;

    //Apply pauli_X given a state vector full of types: doubles/floats
    //ROW 1
    FMUL D7, D1, D5         // D7 = 0 * a
    FMUL D8, D2, D6         // D8 = 1 * b
    FADD D9, D7, D8         // D9 = D7 + D8
    //ROW 2
    FMUL D10, D2, D5        // D10 = 1 * a
    FMUL D11, D1, D6        // D11 = 0 * b
    FADD D12, D11, D10      // D12 = D11 + D10

    //Output the new state of the qubit after
    //the Pauli-X gate has been applied
    STR D9, [X0, #0]        // D9 = Output matrix [0]
    STR D12, [X0, #8]       // D12 = Output matrix [1]

    RET                     // Return to caller

//_pauli_Y:
    // Y = (0 -i ​i 0​)
    // Define pauli_Y gate
    //FMOV D1, #0.0
    //FMOV D2, #1.0

    //LDR D3, [X0, #0]      // = a
    //LDR D4, [X0, #8]      // = b

    // (0⋅α + -i⋅β
    //  (i)⋅α + 0⋅β​)=(α−β​)
    // ROW 1
    //FMUL D5, D1, D2
    //FMUL D6, D2, D4
    //FADD D7, D5, D6
    //VCMPE.D64 D7, D1      // Compare double-precision floating-point values in D7 and D1
    //VMRS APSR_nzcv, FPSCR // Move the result of the comparison to APSR (Application Program Status Register)


_PZ:
    //Define Pauli_Z gate:
    // [1.0,  0.0]
    // [0.0, -1.0]
    FMOV D1, #1.0           // D1 = 1.0; PZ matrix number
    FMOV D2, #0.0           // D2 = 0.0; PZ matrix number
    // -1.0
    FMOV D3, #1.0           // D3 = -1.0 PZ matrix number
    FNEG D3, D3             // -1.0

    // Load vector numbers:
    LDR D5, [X0, #0]        // D5 = qubit vector 1;
    LDR D6, [X0, #8]        // D6 = qubit vector 2;

    // ROW 1:
    FMUL D7, D1, D5         //D7 = 1.0 * 0 = 0
    FMUL D8, D2, D6         //D8 = 0.0 * 1.0 = 0
    FADD D9, D7, D8         //D7 = 0 + 0 = 0

    //ROW 2:
    FMUL D10, D2, D5        //D8 = 0.0 * 0.0 = 0
    FMUL D11, D3, D6        //D9 = -1 * 1 = -1
    FADD D12, D10, D11      //D10 = 0 + (-1) = -1

    STR D9, [X0, #0]        // Store resultant 
    STR D12, [X0, #8]       // Store resultant

    RET                     // Return to caller.

_IM2x2:
    //Identity Matrix
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

_H:
    // Input: x0 -> pointer to qubit state
    // Output: Applies Hadamard to qubit (q[0], q[1])
    
    LDP D0, D1, [x0]        // Load qubit (α_real, α_imag)
    LDP D2, D3, [x0, #16]   // Load qubit (β_real, β_imag)
    
    FADD D4, D0, D2         // α_real + _real β
    FADD D5, D1, D3         // α_imag + β_imag

    FSUB D6, D0, D2         // _real - _real β
    FSUB D7, D1, D3         // _imag - β_imag

    LDR D8, sqrt2_inv       // d8 = 1/sqrt(2)

    FMUL D4, D4, D8         // Scale by sqrt(2)
    FMUL D5, D5, D8
    FMUL D6, D6, D8         // Scale by sqrt(2)
    FMUL D7, D7, D8

    STP D4, D5, [x0]        // Store resultant
    STP D6, D7, [x0, #16]   // Store resultant

    RET

_CNOT:
    // Load control qubit (qubit 1)
    LDP D1, D2, [X0]        // Load real and imaginary parts of |0> component of control qubit
    LDP D3, D4, [X0, #16]   // Load real and imaginary parts of |1> component of control qubit

    // Load target qubit (qubit 2)
    LDP D5, D6, [X1]        // Load real and imaginary parts of |0> component of target qubit
    LDP D7, D8, [X1, #16]   // Load real and imaginary parts of |1> component of target qubit

    // Compute the new state for the target qubit:
    // New |0> component of target qubit: (control |0> * target |0>) + (control |1> * target |1>)
    // New |1> component of target qubit: (control |0> * target |1>) + (control |1> * target |0>)

    // Compute new |0> component (real and imaginary parts)
    FMUL D9, D1, D5         // D9 = control |0> real * target |0> real
    FMUL D10, D2, D6        // D10 = control |0> imag * target |0> imag
    FADD D11, D9, D10       // D11 = new |0> real component

    FMUL D12, D3, D7        // D12 = control |1> real * target |1> real
    FMUL D13, D4, D8        // D13 = control |1> imag * target |1> imag
    FADD D14, D12, D13      // D14 = new |0> imag component

    // Compute new |1> component (real and imaginary parts)
    FMUL D15, D1, D7        // D15 = control |0> real * target |1> real
    FMUL D16, D2, D8        // D16 = control |0> imag * target |1> imag
    FADD D17, D15, D16      // D17 = new |1> real component

    FMUL D18, D3, D5        // D18 = control |1> real * target |0> real
    FMUL D19, D4, D6        // D19 = control |1> imag * target |0> imag
    FADD D20, D18, D19      // D20 = new |1> imag component

    // Store the updated target qubit values
    STP D11, D14, [X1]      // Store new |0> component (real and imaginary)
    STP D17, D20, [X1, #8]  // Store new |1> component (real and imaginary)

    RET                     // Return to caller



_CCNOT:
    // Load QUBIT 1 and QUBIT 2 (control qubits)
    LDR D1, [X0, #0]
    LDR D3, [X1, #0]

    // Load QUBIT 3 (target qubit)
    LDR D5, [X2, #0]
    LDR D6, [X2, #8]

    // Normalize and check control qubits
    FMOV D8, #0.0
    FMOV D9, #2.0
    FDIV D1, D1, D9
    FDIV D3, D3, D9

    FCMP D1, D8
    BNE ZERO
    FCMP D3, D8
    BNE ZERO

    // Apply Pauli-X by swapping qubit 3's values
    FMOV D9, D5
    FMOV D5, D6
    FMOV D6, D9

    // Store the swapped values back to the target qubit
    STR D5, [X2, #0]
    STR D6, [X2, #8]

    RET

_CZ:
    // Load QUBIT 1
    LDR D1, [X0, #0]        // D1 = qubit1 vector 1;
    LDR D2, [X0, #8]        // D2 = qubit1 vector 2;

    // Load QUBIT 2
    LDR D3, [X1, #0]        // D3 = qubit1 vector 1;
    LDR D4, [X1, #8]        // D4 = qubit1 vector 2;

    FMOV D5, #2.0           // D5 = 2.0; CZ matrix number
    FMOV D6, #0.0           // D6 = 0.0; CZ matrix number

    FDIV D1, D1, D5
    FCMP D1, D6
    BNE ZERO                // IF D1 != 0; JUMP TO ZERO...

    //Apply Pauli-Z
    FMOV D1, #1.0           // D1 = 1.0
    FMOV D2, #0.0           // D2 = 0.0
    // -1.0
    FMOV D3, #1.0           // D3 = -1.0
    FNEG D3, D3

    // ROW 1:
    FMUL D7, D1, D3         //D7 = 1.0 * 0 = 0
    FMUL D8, D2, D4         //D8 = 0.0 * 1.0 = 0
    FADD D9, D7, D8         //D7 = 0 + 0 = 0

    //ROW 2:
    FMUL D10, D2, D3        //D8 = 0.0 * 0.0 = 0
    FMUL D11, D3, D4        //D9 = -1 * 1 = -1
    FADD D12, D10, D11      //D10 = 0 + (-1) = -1

    STR D9, [X1, #0]        // Store resultant
    STR D12, [X1, #8]       // Store resultant

    RET                     // Return to caller.

_SWAP:
    // Load the two target qubits if the control qubit is 1
    LDR D1, [X0, #0]        // Load the first element of target qubit 1 into D0
    LDR D2, [X0, #8]        // Load the second element of target qubit 1 into D1

    LDR D3, [X1, #0]        // Load the first element of target qubit 2 into D2
    LDR D4, [X1, #8]        // Load the second element of target qubit 2 into D3

    // Perform the SWAP operation
    STR D1, [X1, #0]        // Store the first element of qubit 1 into qubit 2
    STR D2, [X1, #8]        // Store the second element of qubit 1 into qubit 2

    STR D3, [X0, #0]        // Store the first element of qubit 2 into qubit 1
    STR D4, [X0, #8]        // Store the second element of qubit 2 into qubit

    RET

_FREDKIN:
    // Load the first element of the control qubit
    LDR D0, [X0, #0]        // Control qubit value at X0

    FMOV D1, #0.0           // Set D1 to 0.0 for comparison
    FCMP D1, D0             // Compare control qubit with 0.0
    BNE PERFORM_SWAP        // If control qubit is |1>, perform swap

    RET                     // If control qubit is |0>, return without changes

PERFORM_SWAP:
    // Load the two target qubits
    LDR D1, [X1, #0]        // Target qubit 1 (qubit2[0])
    LDR D2, [X1, #8]        // Target qubit 1 (qubit2[1])

    LDR D3, [X2, #0]        // Target qubit 2 (qubit[0])
    LDR D4, [X2, #8]        // Target qubit 2 (qubit[1])

    // Perform the swap
    STR D1, [X2, #0]        // Store qubit2[0] into qubit[0]
    STR D2, [X2, #8]        // Store qubit2[1] into qubit[1]

    STR D3, [X1, #0]        // Store qubit[0] into qubit2[0]
    STR D4, [X1, #8]        // Store qubit[1] into qubit2[1]

    RET                     // Return to caller after performing swap

_CP:
    //The unit 'i' is approximated to pi/2
    // Load control qubit (qubit 1)
    LDR D1, [X0, #0]        // Load real part of qubit 1
    LDR D2, [X0, #8]        // Load imaginary part of qubit 1

    // Load target qubit (qubit 2)
    LDR D3, [X1, #0]        // Load real part of qubit 2
    LDR D4, [X1, #8]        // Load imaginary part of qubit 2

    // Load the phase angle (e.g., pi/2)
    LDR D5, [X2, #0]        // Load real part of phase angle
    LDR D6, [X2, #8]        // Load imaginary part of phase angle (if any)

    FMOV D7, #0.0  // Load 0 (for comparison)
    FMOV D8, #1.0            // Constant 1 for normalization

    // Normalize the control qubit's state
    FDIV D1, D1, D8
    FDIV D2, D2, D8

    FCMP D1, D7              // Check if control qubit is in state |1>
    BEQ ZERO                 // If control qubit is not |1>, skip phase application

    // Apply the phase shift if control qubit is |1>
    // Multiply target qubit by the phase angle: e^(i*phase) = cos(phase) + i*sin(phase)

    // Real part of the target qubit after applying phase
    FMUL D9, D3, D5         // D9 = target real * phase real
    FMUL D10, D4, D6        // D10 = target imaginary * phase imaginary
    FADD D9, D9, D10        // D9 = target real * phase real + target imaginary * phase imaginary

    // Imaginary part of the target qubit after applying phase
    FMUL D10, D3, D6        // D10 = target real * phase imaginary
    FMUL D11, D4, D5        // D11 = target imaginary * phase real
    FADD D10, D10, D11      // D10 = target real * phase imaginary + target imaginary * phase real

    // Store the updated target qubit values back
    STR D9, [X1, #0]        // Store the real part of qubit 2
    STR D10, [X1, #8]       // Store the imaginary part of qubit 2

    RET                     // Return from function

ZERO:
    RET                     // Return if control qubit is not in state |1>
