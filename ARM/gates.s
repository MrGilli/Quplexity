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



_PX:
    // Define Pauli_X gate:
    // [0.0, 1.0]
    // [1.0, 0.0]
    LDR D1, =0x0000000000000000
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
    STR D9, [X0, #0]    //D9 = Output matrix [0]
    STR D12, [X0, #8]   //D12 = Output matrix [1]

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


_PZ:
    //Define Pauli_Z gate:
    // [1.0,  0.0]
    // [0.0, -1.0]
    FMOV D1, #1.0   // D1 = 1.0
    LDR D2, =0x0000000000000000   // D2 = 0.0
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

    STR D9, [X0, #0] // 0
    STR D12, [X0, #8] // 0

    RET                 // Return to caller.

_IM2x2:
    //Identity Matrix
    // I=(1 0 ​0 1​)
    //(a×1 + b×0, ​a×0 + b×1)
    //(c×1 + d×0, c×0 + d×1​)
    LDR D1, =0x0000000000000000
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
    LDR D1, [X0]
    LDR D2, [X0, #8]

    FMOV D3, #1.0
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

    STR D5, [X0, #0]
    STR D6, [X0, #8]
    
    RET 

_CNOT:
    // Load QUBIT 1
    LDR D1, [X0, #0]        
    LDR D2, [X0, #8]

    // Load QUBIT 2
    LDR D3, [X1, #0]        
    LDR D4, [X1, #8]

    FMOV D5, #2.0
    LDR D6, =0x0000000000000000

    // Normalize and check control qubit
    FDIV D1, D1, D5 
    FCMP D1, D6 
    BNE ZERO            // If not in |1> state, skip

    // Apply Pauli-X by swapping qubits
    FMOV D9, D3         // Row 1: Copy D3 (qubit 3's value)
    FMOV D3, D4         // Row 2: Swap D4 into D3
    FMOV D4, D9         // Store D3's original value into D4

    // Store the swapped values back to the target qubit
    STR D3, [X1, #0]        
    STR D4, [X1, #8]

    RET


_CCNOT:
    // Load QUBIT 1 and QUBIT 2 (control qubits)
    LDR D1, [X0, #0]        
    LDR D3, [X1, #0]

    // Load QUBIT 3 (target qubit)
    LDR D5, [X2, #0]        
    LDR D6, [X2, #8]        

    // Normalize and check control qubits
    LDR D8, =0x0000000000000000
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
    LDR D1, [X0, #0]        
    LDR D2, [X0, #8]        

    // Load QUBIT 2
    LDR D3, [X1, #0]        
    LDR D4, [X1, #8] 

    FMOV D5, #2.0
    LDR D6, =0x0000000000000000

    FDIV D1, D1, D5 
    FCMP D1, D6 
    BNE ZERO

    //Apply Pauli-Z
    FMOV D1, #1.0   // D1 = 1.0
    LDR D2, =0x0000000000000000  // D2 = 0.0
    // -1.0
    FMOV D3, #1.0   // D3 = -1.0
    FNEG D3, D3

    // (1⋅α + 0⋅β 
    //  0⋅α + (−1)⋅β​)=(α−β​)
    // ROW 1:
    FMUL D7, D1, D3 //D7 = 1.0 * 0 = 0
    FMUL D8, D2, D4 //D8 = 0.0 * 1.0 = 0
    FADD D9, D7, D8 //D7 = 0 + 0 = 0

    //ROW 2:
    FMUL D10, D2, D3 //D8 = 0.0 * 0.0 = 0
    FMUL D11, D3, D4 //D9 = -1 * 1 = -1
    FADD D12, D10, D11 //D10 = 0 + (-1) = -1

    STR D9, [X1, #0] // 0
    STR D12, [X1, #8] // 0

    RET                 // Return to caller.

_SWAP:
    // Load the two target qubits if the control qubit is 1
    LDR D1, [X0, #0]    // Load the first element of target qubit 1 into D0
    LDR D2, [X0, #8]    // Load the second element of target qubit 1 into D1

    LDR D3, [X1, #0]    // Load the first element of target qubit 2 into D2
    LDR D4, [X1, #8]    // Load the second element of target qubit 2 into D3

    // Perform the SWAP operation
    STR D1, [X1, #0]    // Store the first element of qubit 1 into qubit 2
    STR D2, [X1, #8]    // Store the second element of qubit 1 into qubit 2

    STR D3, [X0, #0]    // Store the first element of qubit 2 into qubit 1
    STR D4, [X0, #8]    // Store the second element of qubit 2 into qubit 

    RET

_FREDKIN:
    // Load the first element of the control qubit
    LDR D0, [X0, #0]    // Control qubit value at X0

    LDR D1, =0x0000000000000000       // Set D1 to 0.0 for comparison
    FCMP D1, D0         // Compare control qubit with 0.0
    BNE PERFORM_SWAP    // If control qubit is |1⟩, perform swap

    RET                 // If control qubit is |0⟩, return without changes

PERFORM_SWAP:
    // Load the two target qubits
    LDR D1, [X1, #0]    // Target qubit 1 (qubit2[0])
    LDR D2, [X1, #8]    // Target qubit 1 (qubit2[1])

    LDR D3, [X2, #0]    // Target qubit 2 (qubit[0])
    LDR D4, [X2, #8]    // Target qubit 2 (qubit[1])

    // Perform the swap
    STR D1, [X2, #0]    // Store qubit2[0] into qubit[0]
    STR D2, [X2, #8]    // Store qubit2[1] into qubit[1]

    STR D3, [X1, #0]    // Store qubit[0] into qubit2[0]
    STR D4, [X1, #8]    // Store qubit[1] into qubit2[1]

    RET                 // Return to caller after performing swap

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

    LDR D7, =0x0000000000000000  // Load 0 (for comparison)
    FMOV D8, #1.0            // Constant 1 for normalization

    // Normalize the control qubit's state
    FDIV D1, D1, D8         
    FDIV D2, D2, D8         

    FCMP D1, D7              // Check if control qubit is in state |1⟩
    BEQ ZERO                 // If control qubit is not |1⟩, skip phase application

    // Apply the phase shift if control qubit is |1⟩
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

    RET                      // Return from function

ZERO:
    RET                      // Return if control qubit is not in state |1⟩
