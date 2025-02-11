#include <stdio.h>
#include <xmmintrin.h>
#include <math.h>

extern void _PX(double *qubit);
extern void _PY(double *qubit);
extern void _PZ(double *qubit);
extern void _H(double *qubit);
extern void _CNOT(double *qc, double *qt);
extern void _CCNOT(double *q1, double *q2, double *q3);
extern void _CZ(double *qc, double *qt);

static inline double* init(double ar, double ai, double br, double bi) {
    double* q = _mm_malloc(4 * sizeof(double), 16);
    q[0] = ar;  // alpha real
    q[1] = ai;  // alpha imag
    q[2] = br;  // beta real
    q[3] = bi;  // beta imag
    return q;
}

void print_qubit(const char* label, double* q) {
    printf("%s: %lf + %lfi, %lf + %lfi\n", label, q[0], q[1], q[2], q[3]);
}

int main() {
    double* qubit = init(1.0, 0.0, 0.0, 0.0); // |0⟩ state
    print_qubit("Initial Qubit", qubit);

    _PX(qubit);
    print_qubit("Qubit after applying Pauli X gate", qubit);

    _PZ(qubit);
    print_qubit("Qubit after applying Pauli Z gate", qubit);

    return 0;
}
