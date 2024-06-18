#include <stdio.h>
#include <string.h>

int main() {
    char cmd[256];
    printf("QCVM - Quantum Computer Virtual Machine. \n");
    printf("Type 'help' to list commands. \n");
    while (1) {
        printf("$ ");
        if (fgets(cmd, sizeof(cmd), stdin) != NULL) {
            // Remove the trailing newline character
            cmd[strcspn(cmd, "\n")] = '\0';
            
            if (strcmp(cmd, "exit") == 0) {
                printf("Exiting QCVM \n");
                break;
            } else if (strstr(cmd, "init") != NULL) {
                printf("The word 'init' was found in your input.\n");
            } else {
                printf("The word 'init' was not found in your input.\n");
            }
            printf("You entered: %s\n", cmd);
        }
    }
    return 0;
}
