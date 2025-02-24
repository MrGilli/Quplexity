//; © Jacob Liam Gill 2025. All rights reserved. **DO NOT REMOVE THIS LINE.**
//; Quplexity MUST be credited in the project you use it in either throughout documentation and/or in the code base. **DO NOT REMOVE THIS LINE.**

//; I'm striving to make the code for Quplexity as readable as possible.
//; If you would like to contribute or contact me for any other reason please don't hesitate to email me: jacobygill@outlook.com
//; Or DM/friend request me on Discord: @mrgill0651

.global _QuantumCircuit
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



_QuantumCircuit:
    // Input: x0 = num_qubits, x1 = pointer to statevector array

    cbz x1, abort_handler  // Safety check: if statevector pointer is NULL, abort

    mov x2, #1             // Compute number of states: x2 = 2^num_qubits
    lsl x2, x2, x0         // x2 = 1 << num_qubits
    lsl x2, x2, #1         // x2 = 2 * (1 << num_qubits), accounting for real & imag

    fmov d0, 1.0           // Set |00⟩ = 1 + 0i (first entry)
    fmov d1, 0.0

    mov x3, #0             // Loop counter

init_loop:
    cmp x3, x2             // If x3 >= total statevector size, exit
    bge done              

    add x4, x1, x3, lsl #3 // Compute address: statevector[x3]
    stp d0, d1, [x4]       // Store real and imaginary parts

    fmov d0, 0.0           // Set next states to 0 + 0i
    fmov d1, 0.0

    add x3, x3, #2         // Move to the next complex number
    b init_loop

done:
    ret

abort_handler:
    brk #0                 // error if statevector is NULL
    

_PX:
    FMOV D1, #0.0           //; D1 = 0.0; PX matrix number
    FMOV D2, #1.0           //; D2 = 1.0; PX matrix number


    LDR D5, [X0, #0]        //; D5 = qubit vector 1;
    LDR D6, [X0, #8]        //; D6 = qubit vector 2;

    //Apply pauli_X given a state vector full of types: doubles/floats
    //ROW 1
    FMUL D7, D1, D5         //; D7 = 0 * a
    FMUL D8, D2, D6         //; D8 = 1 * b
    FADD D9, D7, D8         //; D9 = D7 + D8
    //ROW 2
    FMUL D10, D2, D5        //; D10 = 1 * a
    FMUL D11, D1, D6        //; D11 = 0 * b
    FADD D12, D11, D10      //; D12 = D11 + D10

    //Output the new state of the qubit after
    //the Pauli-X gate has been applied
    STR D9, [X0, #0]        //; D9 = Output matrix [0]
    STR D12, [X0, #8]       //; D12 = Output matrix [1]

    RET                     //; Return to caller

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
    //;Define Pauli_Z gate:
    //; [1.0,  0.0]
    //; [0.0, -1.0]
    FMOV D1, #1.0           //; D1 = 1.0; PZ matrix number
    FMOV D2, #0.0           //; D2 = 0.0; PZ matrix number
    //; -1.0
    FMOV D3, #1.0           //; D3 = -1.0 PZ matrix number
    FNEG D3, D3             //; -1.0

    //; Load vector numbers:
    LDR D5, [X0, #0]        //; D5 = qubit vector 1;
    LDR D6, [X0, #8]        //; D6 = qubit vector 2;

    //; ROW 1:
    FMUL D7, D1, D5         //; D7 = 1.0 * 0 = 0
    FMUL D8, D2, D6         //; D8 = 0.0 * 1.0 = 0
    FADD D9, D7, D8         //; D7 = 0 + 0 = 0

    //; ROW 2:
    FMUL D10, D2, D5        //; D8 = 0.0 * 0.0 = 0
    FMUL D11, D3, D6        //; D9 = -1 * 1 = -1
    FADD D12, D10, D11      //; D10 = 0 + (-1) = -1

    STR D9, [X0, #0]        //; Store resultant 
    STR D12, [X0, #8]       //; Store resultant

    RET                     //; Return to caller.

_IM2x2:
    //; Identity Matrix
    FMOV D1, #0.0
    FMOV D2, #1.0

    //; Load Matrix(A) values
    LDR D3, [X0]
    LDR D4, [X0, #8]
    LDR D5, [X0, #16]
    LDR D6, [X0, #24]

    //; ROW 1
    FMUL D7, D2, D3
    FMUL D8, D1, D4
    FADD D9, D8, D7

    FMUL D10, D3, D1
    FMUL D11, D4, D2
    FADD D12, D11, D10

    //; ROW 2
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
    // Input: X0 = qubit_index, X1 = pointer to statevector
    MOV X3, 1                // Set X3 to 1 (the base value for power of 2)
    LSL X3, X3, X0           // Shift X3 left by qubit_index, equivalent to 2^qubit_index

    LDR D2, sqrt2_inv        // Load the value from sqrt2_inv (0.7071) into D2

    // Store sqrt2_inv at the first element of the statevector (X1 points to statevector)
    MOV X4, #1
    //SUB X3, X3, X4
    STR D2, [X1, #0]         // Store D2 (sqrt2_inv) at address X1 (statevector[0])
    ADD X6, X1, X3, lsl #4   // Get address of statevector[x3]
    STR D2, [X6]

    RET
    


_CNOT:
    // Calculate the byte offset for the control qubit (each qubit has 4 doubles = 32 bytes)
    MOV X3, X0          // control_index
    LSL X3, X3, #5      // Multiply by 32 (since each qubit has 4 doubles, each double is 8 bytes)

    // Calculate the byte offset for the target qubit
    MOV X4, X1          // target_index
    LSL X4, X4, #5      // Multiply by 32 (since each qubit has 4 doubles)

    // Get the addresses of the control and target qubits
    ADD X3, X3, X2      // x3 = address of control qubit (pointer to qubits array)
    ADD X4, X4, X2      // x4 = address of target qubit

    // Load the real part (a_real) of the control qubit
    LDR D0, [X3]        // Load a_real of control qubit into d0

    // Compare if the real part of the control qubit is 0
    FCMP D0, #0.0       // If d0 (a_real) == 0, no action; if d0 != 0, proceed to swap
    BEQ ZERO     // If control qubit's real part is zero, go to ZERO

    // Swap the a_real values of control and target qubits
    LDR D1, [X3]        // Load a_real of target qubit into d1
    STR D1, [X4]    // Store a_real into b_real of target qubit

    LDR D3, [X3, #16]    // Load a_imag of target qubit into d1
    STR D3, [X4, #16]   // Store a_imag into b_imag of target qubit


    RET



_CCNOT:
    //; Load QUBIT 1 and QUBIT 2 (control qubits)
    LDR D1, [X0, #0]
    LDR D3, [X1, #0]

    //; Load QUBIT 3 (target qubit)
    LDR D5, [X2, #0]
    LDR D6, [X2, #8]

    //; Normalize and check control qubits
    FMOV D8, #0.0
    FMOV D9, #2.0
    FDIV D1, D1, D9
    FDIV D3, D3, D9

    FCMP D1, D8
    BNE ZERO
    FCMP D3, D8
    BNE ZERO

    //; Apply Pauli-X by swapping qubit 3's values
    FMOV D9, D5
    FMOV D5, D6
    FMOV D6, D9

    //; Store the swapped values back to the target qubit
    STR D5, [X2, #0]
    STR D6, [X2, #8]

    RET

_CZ:
    //; Load QUBIT 1
    LDR D1, [X0, #0]        //; D1 = qubit1 vector 1;
    LDR D2, [X0, #8]        //; D2 = qubit1 vector 2;

    //; Load QUBIT 2
    LDR D3, [X1, #0]        //; D3 = qubit1 vector 1;
    LDR D4, [X1, #8]        //; D4 = qubit1 vector 2;

    FMOV D5, #2.0           //; D5 = 2.0; CZ matrix number
    FMOV D6, #0.0           //; D6 = 0.0; CZ matrix number

    FDIV D1, D1, D5
    FCMP D1, D6
    BNE ZERO                //; IF D1 != 0; JUMP TO ZERO...

    //; Apply Pauli-Z
    FMOV D1, #1.0           //; D1 = 1.0
    FMOV D2, #0.0           //; D2 = 0.0
    //; -1.0
    FMOV D3, #1.0           //; D3 = -1.0
    FNEG D3, D3

    //; ROW 1:
    FMUL D7, D1, D3         //; D7 = 1.0 * 0 = 0
    FMUL D8, D2, D4         //; D8 = 0.0 * 1.0 = 0
    FADD D9, D7, D8         //; D7 = 0 + 0 = 0

    //; ROW 2:
    FMUL D10, D2, D3        //; D8 = 0.0 * 0.0 = 0
    FMUL D11, D3, D4        //; D9 = -1 * 1 = -1
    FADD D12, D10, D11      //; D10 = 0 + (-1) = -1

    STR D9, [X1, #0]        //; Store resultant
    STR D12, [X1, #8]       //; Store resultant

    RET                     //; Return to caller.

_SWAP:
    //; Load the two target qubits if the control qubit is 1
    LDR D1, [X0, #0]        //; Load the first element of target qubit 1 into D0
    LDR D2, [X0, #8]        //; Load the second element of target qubit 1 into D1

    LDR D3, [X1, #0]        //; Load the first element of target qubit 2 into D2
    LDR D4, [X1, #8]        //; Load the second element of target qubit 2 into D3

    //; Perform the SWAP operation
    STR D1, [X1, #0]        //; Store the first element of qubit 1 into qubit 2
    STR D2, [X1, #8]        //; Store the second element of qubit 1 into qubit 2

    STR D3, [X0, #0]        //; Store the first element of qubit 2 into qubit 1
    STR D4, [X0, #8]        //; Store the second element of qubit 2 into qubit

    RET

_FREDKIN:
    //; Load the first element of the control qubit
    LDR D0, [X0, #0]        //; Control qubit value at X0

    FMOV D1, #0.0           //; Set D1 to 0.0 for comparison
    FCMP D1, D0             //; Compare control qubit with 0.0
    BNE PERFORM_SWAP        //; If control qubit is |1>, perform swap

    RET                     //; If control qubit is |0>, return without changes

PERFORM_SWAP:
    //; Load the two target qubits
    LDR D1, [X1, #0]        //; Target qubit 1 (qubit2[0])
    LDR D2, [X1, #8]        //; Target qubit 1 (qubit2[1])

    LDR D3, [X2, #0]        //; Target qubit 2 (qubit[0])
    LDR D4, [X2, #8]        //; Target qubit 2 (qubit[1])

    // Perform the swap
    STR D1, [X2, #0]        //; Store qubit2[0] into qubit[0]
    STR D2, [X2, #8]        //; Store qubit2[1] into qubit[1]

    STR D3, [X1, #0]        //; Store qubit[0] into qubit2[0]
    STR D4, [X1, #8]        //; Store qubit[1] into qubit2[1]

    RET                     //; Return to caller after performing swap

_CP:
    //; Load control qubit (qubit 1)
    LDR D1, [X0, #0]        //; Load real part of qubit 1
    LDR D2, [X0, #8]        //; Load imaginary part of qubit 1

    //; Load target qubit (qubit 2)
    LDR D3, [X1, #0]        //; Load real part of qubit 2
    LDR D4, [X1, #8]        //; Load imaginary part of qubit 2

    //; Load the phase angle (e.g., pi/2)
    LDR D5, [X2, #0]        //; Load real part of phase angle
    LDR D6, [X2, #8]        //; Load imaginary part of phase angle (if any)

    FMOV D7, #0.0           //; Load 0 (for comparison)
    FMOV D8, #1.0           //; Constant 1 for normalization

    //; Normalize the control qubit's state
    FDIV D1, D1, D8
    FDIV D2, D2, D8

    FCMP D1, D7             //; Check if control qubit is in state |1>
    BEQ ZERO                //; If control qubit is not |1>, skip phase application

    //; Apply the phase shift if control qubit is |1>
    //; Multiply target qubit by the phase angle: e^(i*phase) = cos(phase) + i*sin(phase)

    //; Real part of the target qubit after applying phase
    FMUL D9, D3, D5         //; D9 = target real * phase real
    FMUL D10, D4, D6        //; D10 = target imaginary * phase imaginary
    FADD D9, D9, D10        //; D9 = target real * phase real + target imaginary * phase imaginary

    //; Imaginary part of the target qubit after applying phase
    FMUL D10, D3, D6        //; D10 = target real * phase imaginary
    FMUL D11, D4, D5        //; D11 = target imaginary * phase real
    FADD D10, D10, D11      //; D10 = target real * phase imaginary + target imaginary * phase real

    //; Store the updated target qubit values back
    STR D9, [X1, #0]        //; Store the real part of qubit 2
    STR D10, [X1, #8]       //; Store the imaginary part of qubit 2

    RET                     //; Return from function

ZERO:
    RET                     //; Return if control qubit is not in state |1>
