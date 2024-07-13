#ifndef QUANTUM_H
#define QUANTUM_H

#include <complex>

typedef std::complex<double> Complex;

extern "C" {
    Complex* initializeState(int numQubits);
    void applySingleQubitGate(Complex *stateVector, int numQubits, Complex gate[2][2], int targetQubit);
    void printQuantumState(Complex *stateVector, int numQubits);
    int measureQubit(Complex *stateVector, int numQubits, int targetQubit);
    int calculate_dimension_(int numQubits);
}

#endif
