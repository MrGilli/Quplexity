#ifndef QUANTUM_H
#define QUANTUM_H

#include <complex>

using Complex = std::complex<double>;

struct QuantumState {
    int numQubits;
    Complex *stateVector;
};

QuantumState* initializeState(int numQubits);
void applySingleQubitGate(QuantumState *qs, Complex gate[2][2], int targetQubit);
void printQuantumState(QuantumState *qs);
int measureQubit(Complex *stateVector, int numQubits, int targetQubit);

#endif
