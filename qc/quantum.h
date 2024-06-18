#ifndef  QUANTUM
#define QUANTUM


#include <complex.h>
// Define a complex number type using C's complex.h library
typedef double complex Complex;

// Function declarations
Complex*  initializeState(int numQubits);
void applySingleQubitGate(Complex *stateVector, int numQubits, Complex gate[2][2], int targetQubit);
int measureQubit(Complex *stateVector, int numQubits, int targetQubit);

// Common gates
extern Complex hadamard[2][2];

#endif