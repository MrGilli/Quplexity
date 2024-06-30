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

void square() {
    int a, b, c, d, result;

    a = 10; b = 20; c = 30; d = 18;
    result = IntegerAddSub_(a, b, c, d);

    a = 101; b = 34; c = -190; d = 25;
    result = IntegerAddSub_(a, b, c, d);
}

int main() {
    checkMemory();
    bool normal_input = true;
    char cmd[256];
    QuantumState *qs = nullptr;

    cout << "Quplexity - Blazingly Fast Quantum Computer Simulation Software." << endl;
    cout << "Type 'help' to list commands." << endl;
    while (normal_input) {
        cout << "$ ";
        if (fgets(cmd, sizeof(cmd), stdin) != nullptr) {
            cmd[strcspn(cmd, "\n")] = '\0';

            if (strcmp(cmd, "exit") == 0) {
                cout << "Exiting QCVM" << endl;
                break;
            } else if (strstr(cmd, "Q") != nullptr) {
                int num_of_qubits = extractNumber(cmd);
                if (qs != nullptr) {
                    delete[] qs->stateVector;
                    delete qs;
                }
                qs = initializeState(num_of_qubits);
                cout << "Initialized " << num_of_qubits << " qubit(s) in the quantum circuit." << endl;

                bool prompt = true;
                char cmd2[256];
                while (prompt) {
                    cout << "[circuit]$ ";
                    if (fgets(cmd2, sizeof(cmd2), stdin) != nullptr) {
                        cmd2[strcspn(cmd2, "\n")] = '\0';
                        if (strstr(cmd2, "H") != nullptr) {
                            int qubit_index = extractNumber(cmd2);
                            Complex hadamard[2][2] = {
                                {1.0 / sqrt(2), 1.0 / sqrt(2)},
                                {1.0 / sqrt(2), -1.0 / sqrt(2)}
                            };

                            applySingleQubitGate(qs, hadamard, qubit_index);
                            printQuantumState(qs);
                            cout << "Applied Hadamard gate to qubit of index " << qubit_index << endl;
                        } else if (strcmp(cmd2, "exit") == 0) {
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
    if (qs != nullptr) {
        delete[] qs->stateVector;
        delete qs;
    }
    return 0;
}
