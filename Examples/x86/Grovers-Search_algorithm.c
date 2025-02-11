#include <stdio.h>
#include <stdlib.h>
#include <xmmintrin.h>

extern void _H_basic(double *qubit);
extern void _PX(double *qubit);
extern void _PZ(double *qubit);
extern void _CNOT(double *qc, double *qt);

static inline double* init(double x, double y){
    double* q = _mm_malloc(2 * sizeof(double), 16);
    q[0] = x;
    q[1] = y;
    return q;
}

void print_qubit(const char* label, double* qubit) {
    printf("%s: = %lf, %lf\n", label, qubit[0], qubit[1]);
}


void oracle(double* qubit) {
    _PZ(qubit);  // Phase flip if the qubit is in the correct state (we assume it's the marked state)
}

void diffusion_operator(double* qubit) {
    _H_basic(qubit);  // Apply Hadamard transform to the qubit
    _PZ(qubit);       // Apply phase flip
    _H_basic(qubit);  // Apply another Hadamard transform to complete the inversion
}

int main() {
    printf("Grover's Search Algorithm\n");

    double* qubit = init(1.0, 0.0); 
    _H_basic(qubit);
    print_qubit("Initial Superposition", qubit);


    int iterations = 1; 
    for (int i = 0; i < iterations; i++) {
        oracle(qubit);
        diffusion_operator(qubit);
    }

    
    print_qubit("Final State", qubit);

	if (qubit[0] < qubit[1]){
		printf("|1> Is the most likely outcome.\n");
	}else {
		printf("|0> Is the most likely outcome.\n");
	}

    _mm_free(qubit);
    
    return 0;
}
