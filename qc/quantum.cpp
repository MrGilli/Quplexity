#include "quantum.h"
#include <cstdlib> // For malloc and free
#include <cmath>   // For pow and cabs
#include <iostream>

extern "C" int calculate_dimension_(int numQubits);

// Initialize quantum state
QuantumState* initializeState(int numQubits) {
    QuantumState *qs = new QuantumState;
    qs->numQubits = numQubits;
    int dimension = calculate_dimension_(numQubits);
    qs->stateVector = new Complex[dimension];
    for (int i = 0; i < dimension; i++) {
        qs->stateVector[i] = Complex(0.0, 0.0);
    }
    qs->stateVector[0] = Complex(1.0, 0.0); // Initialize to |0>
    return qs;
}

// Apply a single qubit gate
void applySingleQubitGate(QuantumState *qs, Complex gate[2][2], int targetQubit) {
    int dimension = calculate_dimension_(qs->numQubits);
    Complex *newStateVector = new Complex[dimension];

    for (int i = 0; i < dimension; i++) {
        int bit = (i >> targetQubit) & 1;
        int base = i & (~(1 << targetQubit));
        newStateVector[i] = gate[bit][0] * qs->stateVector[base] + gate[bit][1] * qs->stateVector[base | (1 << targetQubit)];
    }

    for (int i = 0; i < dimension; i++) {
        qs->stateVector[i] = newStateVector[i];
    }

    delete[] newStateVector;
}

// Print quantum state
void printQuantumState(QuantumState *qs) {
    int dimension = 1 << qs->numQubits;
    for (int i = 0; i < dimension; i++) {
        std::cout << "|" << i << "> = " << qs->stateVector[i].real() << " + " << qs->stateVector[i].imag() << "i\n";
    }
}

// Measure a qubit
int measureQubit(Complex *stateVector, int numQubits, int targetQubit) {
    int dimension = calculate_dimension_(numQubits);
    double probability0 = 0.0;

    for (int i = 0; i < dimension; i++) {
        if (((i >> targetQubit) & 1) == 0) {
            probability0 += std::pow(std::abs(stateVector[i]), 2);
        }
    }

    double randomValue = static_cast<double>(rand()) / RAND_MAX;
    return (randomValue < probability0) ? 0 : 1;
}
