#include <iostream>
#include <cstring>
#include <cmath>
#include "../qc/quantum.h"
#include "./errors.h"

using namespace std;

extern "C" int IntegerAddSub_(int a, int b, int c, int d);

int extractNumber(const char *input) {
    const char *start = strchr(input, '[');
    const char *end = strchr(input, ']');
    if (start != nullptr && end != nullptr && end > start) {
        char numberStr[16];
        strncpy(numberStr, start + 1, end - start - 1);
        numberStr[end - start - 1] = '\0';
        return atoi(numberStr);
    }
    return -1;
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



int main() {
    checkMemory();
    bool normal_input = true;
    char cmd[256];
    cout << "Quplexity - Blazingly Fast Quantum Computer Simulation Software." << endl;
    cout << "Type 'help' to list commands." << endl;

    Complex* stateVector = nullptr;
    int numQubits = 0;

    while (normal_input) {
        cout << "$ ";
        if (fgets(cmd, sizeof(cmd), stdin) != nullptr) {
            cmd[strcspn(cmd, "\n")] = '\0';
            if (strcmp(cmd, "exit") == 0) {
                cout << "Exiting QCVM" << endl;
                break;
            } else if (strstr(cmd, "Q") != nullptr) {
                numQubits = extractNumber(cmd);
                stateVector = initializeState(numQubits);
                cout << "Initialized " << numQubits << " qubit(s) in the quantum circuit." << endl;
            } else if (strstr(cmd, "H") != nullptr) {
                if (stateVector == nullptr) {
                    cout << "Error: No qubits initialized. Please initialize qubits first using Q[n]." << endl;
                    continue;
                }
                int qubit_index = extractNumber(cmd) - 1; // Adjust for 1-based index
                if (qubit_index < 0 || qubit_index >= numQubits) {
                    cout << "Error: Invalid qubit index." << endl;
                    continue;
                }
                Complex hadamard[2][2] = {
                    {1.0 / sqrt(2), 1.0 / sqrt(2)},
                    {1.0 / sqrt(2), -1.0 / sqrt(2)}
                };
                applySingleQubitGate(stateVector, numQubits, hadamard, qubit_index);
                printQuantumState(stateVector, numQubits);
                cout << "Applied Hadamard gate to qubit of index " << qubit_index + 1 << endl;
            } else {
                cout << "Command not found --> '" << cmd << "'" << endl;
            }
        }
        else {
            cout << "Command not found --> '" << cmd << "'" << endl;
        }
    }
    if (stateVector != nullptr) {
        delete[] stateVector;
    }
    return 0;
}
