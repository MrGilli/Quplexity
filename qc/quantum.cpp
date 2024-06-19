#include "quantum.h"
#include <cstdlib> // For malloc and free
#include <cmath>   // For pow and cabs

extern "C" int calculate_dimension_(int numQubits);

// Initialize quantum state
Complex* initializeState(int numQubits) {
    int dimension = calculate_dimension_(numQubits);
    Complex *stateVector = new Complex[dimension];
    for (int i = 0; i < dimension; i++) {
        stateVector[i] = Complex(0.0, 0.0);
    }
    stateVector[0] = Complex(1.0, 0.0); // Initialize to |0>
    return stateVector;
}

// Apply a single qubit gate
void applySingleQubitGate(Complex *stateVector, int numQubits, Complex gate[2][2], int targetQubit) {
    int dimension = calculate_dimension_(numQubits);
    Complex *newStateVector = new Complex[dimension];

    for (int i = 0; i < dimension; i++) {
        int bit = (i >> targetQubit) & 1;
        int base = i & (~(1 << targetQubit));
        newStateVector[i] = gate[bit][0] * stateVector[base] + gate[bit][1] * stateVector[base | (1 << targetQubit)];
    }

    for (int i = 0; i < dimension; i++) {
        stateVector[i] = newStateVector[i];
    }

    delete[] newStateVector;
}

// Measure a qubit
int measureQubit(Complex *stateVector, int numQubits, int targetQubit) {
    int dimension = calculate_dimension_(numQubits);
    double probability0 = 0.0;

    for (int i = 0; i < dimension; i++) {
        if (((i >> targetQubit) & 1) == 0) {
            probability0 += pow(abs(stateVector[i]), 2);
        }
    }

    double randomValue = static_cast<double>(rand()) / RAND_MAX;
    return (randomValue < probability0) ? 0 : 1;
}
