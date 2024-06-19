#include <iostream>
#include <cstring>
#include <cmath>
#include "../qc/quantum.h"

using namespace std;

extern "C" int IntegerAddSub_(int a, int b, int c, int d);

int extractNumber(const char *input) {
    const char *start = strchr(input, '['); // Find the first occurrence of '['
    const char *end = strchr(input, ']');   // Find the first occurrence of ']'

    if (start != nullptr && end != nullptr && end > start) {
        char numberStr[16]; // Buffer to hold the number string
        strncpy(numberStr, start + 1, end - start - 1);
        numberStr[end - start - 1] = '\0'; // Null-terminate the string
        return atoi(numberStr); // Convert the number string to an integer
    }

    return -1; // Return -1 if the format is invalid
}

void PrintResult(const char* msg, int a, int b, int c, int d, int result) {
    cout << msg << endl;
    cout << "a = " << a << endl;
    cout << "b = " << b << endl;
    cout << "c = " << c << endl;
    cout << "d = " << d << endl;
    cout << "result = " << result << endl;
    cout << endl;
}

void square() {
    int a, b, c, d, result;

    a = 10; b = 20; c = 30; d = 18;
    result = IntegerAddSub_(a, b, c, d);
    //PrintResult("Test 1", a, b, c, d, result);

    a = 101; b = 34; c = -190; d = 25;
    result = IntegerAddSub_(a, b, c, d);
    //PrintResult("Test 2", a, b, c, d, result);
}

int main() {
    //square();
    bool normal_input = true;
    char cmd[256];
    cout << "QCVM - Quantum Computer Virtual Machine." << endl;
    cout << "Type 'help' to list commands." << endl;
    while (normal_input) {
        cout << "$ ";
        if (fgets(cmd, sizeof(cmd), stdin) != nullptr) {
            // Remove the trailing newline character
            cmd[strcspn(cmd, "\n")] = '\0';

            if (strcmp(cmd, "exit") == 0) {
                cout << "Exiting QCVM" << endl;
                break;
            } else if (strstr(cmd, "Q") != nullptr) {
                int num_of_qubits = extractNumber(cmd);
                // Initialize Hadamard gate
                int numQubits = num_of_qubits;
                Complex *stateVector = initializeState(numQubits);
                cout << "Initialized " << numQubits << " qubit(s) in the quantum circuit." << endl;
                bool prompt = true;
                char cmd2[256];
                while (prompt) {
                    cout << "[circuit]$ ";
                    if (fgets(cmd2, sizeof(cmd2), stdin) != nullptr) {
                        // Remove the trailing newline character
                        cmd2[strcspn(cmd2, "\n")] = '\0';
                        if (strstr(cmd2, "H") != nullptr) {
                            int qubit_index = extractNumber(cmd2);
                            cout << "Applied Hadamard gate to qubit of index {" << qubit_index << "}" << endl;
                        } else if (strstr(cmd2, "exit") != nullptr) {
                            cout << "Exiting QCVM Circuit" << endl;
                            break;
                        } else {
                            cout << "Command not found --> '" << cmd2 << "'" << endl;
                        }
                    }
                }
            }
        }
    }
    return 0;
}
