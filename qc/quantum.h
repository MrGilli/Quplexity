#ifndef QUANTUM
#define QUANTUM

#include <complex> // Include for complex numbers in C++
using namespace std; // Use std namespace for convenience

// Define a complex number type using C++'s complex library
typedef complex<double> Complex;

// Function declarations
Complex* initializeState(int numQubits);
void applySingleQubitGate(Complex *stateVector, int numQubits, Complex gate[2][2], int targetQubit);
int measureQubit(Complex *stateVector, int numQubits, int targetQubit);

// Common gates
extern Complex hadamard[2][2];

#endif
