#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <xmmintrin.h>

// Quplexity x86 Gates!!
extern void _H_basic(double *qubit);
extern void _CNOT(double *qc, double *qt);
extern void _PZ(double *qubit);
// Quplexity x86 Gates!!


static inline double* init(double x, double y) {
    double* q = _mm_malloc(2 * sizeof(double), 16);
    q[0] = x;
    q[1] = y;
    return q;
}

void print_qubit(const char* label, double* qubit) {
    printf("%s: %lf, %lf\n", label, qubit[0], qubit[1]);
}

// Oracle function (example: balanced function)
void oracle(double* input, double* ancilla) {
    // Example oracle that flips the phase based on the input
    if (input[0] == 1.0 && input[1] == 0.0) {
        _PZ(ancilla); // Apply Pauli-Z to the ancilla qubit
    }
}

int main() {
	printf("The Deutsch-Jozsa algorithm using x86 Quplexity!!\n\n");
    int n = 2;
    double* qubits[n];
    double* ancilla = init(0.0, 1.0);  // |1>

    // Init to |0>
    for (int i = 0; i < n; i++) {
        qubits[i] = init(1.0, 0.0);
    }

    
    for (int i = 0; i < n; i++) {
        _H_basic(qubits[i]);
    }

    _H_basic(ancilla);

    // Oracle
    oracle(qubits[0], ancilla);


    for (int i = 0; i < n; i++) {
        _H_basic(qubits[i]);
    }


	printf("Final measurement results:\n");

	int is_constant = 1; // Assume it's constant

	for (int i = 0; i < n; i++) {
		print_qubit("Qubit", qubits[i]);

		// If any qubit is not in state |0> ([1.0, 0.0]), it's not a constant function
		if (!(qubits[i][0] == 1.0 && qubits[i][1] == 0.0)) {
			is_constant = 0;
		}
	}

	// Determine function type after checking all qubits
	if (is_constant) {
		printf("Hence, the function is CONSTANT.\n");
	} else {
		printf("Hence, the function is BALANCED.\n");
	}
    // Free memory
    for (int i = 0; i < n; i++) {
        _mm_free(qubits[i]);
    }
    _mm_free(ancilla);

    return 0;
}
