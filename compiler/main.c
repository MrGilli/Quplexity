#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include "../qc/quantum.h"

int extractNumber(const char *input) {
    const char *start = strchr(input, '['); // Find the first occurrence of '['
    const char *end = strchr(input, ']');   // Find the first occurrence of ']'
    
    if (start != NULL && end != NULL && end > start) {
        char numberStr[16]; // Buffer to hold the number string
        strncpy(numberStr, start + 1, end - start - 1);
        numberStr[end - start - 1] = '\0'; // Null-terminate the string
        return atoi(numberStr); // Convert the number string to an integer
    }
    
    return -1; // Return -1 if the format is invalid
}


int main() {
    bool normal_input = true;
    char cmd[256];
    printf("QCVM - Quantum Computer Virtual Machine. \n");
    printf("Type 'help' to list commands. \n");
    while (normal_input == true) {
        printf("$ ");
        if (fgets(cmd, sizeof(cmd), stdin) != NULL) {
            // Remove the trailing newline character
            cmd[strcspn(cmd, "\n")] = '\0';
            
            if (strcmp(cmd, "exit") == 0) {
                printf("Exiting QCVM \n");
                break;
            } else if (strstr(cmd, "init") != NULL) {
                int num_of_qubits = extractNumber(cmd);
                // Initialize Hadamard gate
                Complex hadamard[2][2] = {
                    {1.0 / sqrt(2), 1.0 / sqrt(2)},
                    {1.0 / sqrt(2), -1.0 / sqrt(2)}
                };

                int numQubits = num_of_qubits;
                Complex *stateVector = initializeState(numQubits);
                printf("Initialized %d qubit(s) in quantum circuit. \n", numQubits);
                bool prompt = true;
                char cmd2[256];
                while (prompt == true) {
                    printf("$ ");
                    if (fgets(cmd2, sizeof(cmd2), stdin) != NULL) {
                        // Remove the trailing newline character
                        cmd2[strcspn(cmd2, "\n")] = '\0';
                        if (strstr(cmd2, "H") != NULL) {
                            int qubit_index = extractNumber(cmd2);
                            printf("Applying Hadamard gate to qubit of index {%d} \n", qubit_index);
                        }
                    }
                }
            }
        }
    }
    return 0;
}
