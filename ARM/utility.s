.global _pauli_X
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
    //(0⋅α+1⋅β 1⋅α+0⋅β​)=(βα​)

    //ROW 1
    FMUL D7, D1, D5
    FMUL D8, D2, D6
    FADD D9, D5, D6
    //ROW 2
    FMUL D10, D1, D5
    FMUL D11, D2, D6
    FADD D11, D11, D10

    //Output the new state of the qubit after 
    //the Pauli-X gate has been applied
    STR D9, [X1, #0]
    STR D11, [X1, #8]

    RET                 //Return to caller