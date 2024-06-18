#include "quantum.h"
#include <stdlib.h>
#include <math.h>

// Initialize quantum state
Complex* initializeState(int numQubits) {
    int dimension = 1 << numQubits; // 2^numQubits
    Complex *stateVector = (Complex *)malloc(dimension * sizeof(Complex));
    for (int i = 0; i < dimension; i++) {
        stateVector[i] = 0.0 + 0.0*I;
    }
    stateVector[0] = 1.0 + 0.0*I; // Initialize to |0>
    return stateVector;
}

// Apply a single qubit gate
void applySingleQubitGate(Complex *stateVector, int numQubits, Complex gate[2][2], int targetQubit) {
    int dimension = 1 << numQubits;
    Complex *newStateVector = (Complex *)malloc(dimension * sizeof(Complex));

    for (int i = 0; i < dimension; i++) {
        int bit = (i >> targetQubit) & 1;
        int base = i & (~(1 << targetQubit));
        newStateVector[i] = gate[bit][0] * stateVector[base] + gate[bit][1] * stateVector[base | (1 << targetQubit)];
    }

    for (int i = 0; i < dimension; i++) {
        stateVector[i] = newStateVector[i];
    }

    free(newStateVector);
}

// Measure a qubit
int measureQubit(Complex *stateVector, int numQubits, int targetQubit) {
    int dimension = 1 << numQubits;
    double probability0 = 0.0;

    for (int i = 0; i < dimension; i++) {
        if (((i >> targetQubit) & 1) == 0) {
            probability0 += pow(cabs(stateVector[i]), 2);
        }
    }

    double randomValue = (double)rand() / RAND_MAX;
    return (randomValue < probability0) ? 0 : 1;
}
