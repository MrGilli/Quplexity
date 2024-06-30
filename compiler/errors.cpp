#include "errors.h"
#include <iostream>
#include <cmath>

// Function to round RAM to the nearest power of 2 (2, 4, 8, 16, 32, 64, ...)
unsigned int roundToNearestPowerOf2(unsigned int sizeInMB) {
    if (sizeInMB <= 2048) {
        if (sizeInMB <= 1024) {
            return 2048;
        } else {
            return 4096;
        }
    } else if (sizeInMB <= 8192) {
        return 8192;
    } else if (sizeInMB <= 16384) {
        return 16384;
    } else if (sizeInMB <= 32768) {
        return 32768;
    } else {
        return 65536; // Assuming maximum to be 64GB for simplicity
    }
}

unsigned int getMaxQubits(unsigned int sizeInMB) {
    unsigned int roundedSize = roundToNearestPowerOf2(sizeInMB);

    switch (roundedSize) {
        case 2048: return 27;
        case 4096: return 28;
        case 8192: return 29;
        case 16384: return 30;
        case 32768: return 31;
        case 65536: return 32;
        default: return 0; // Error case, should not happen
    }
}

#if defined(_WIN32) || defined(_WIN64)
#include <windows.h>

void checkMemory() {
    MEMORYSTATUSEX status;
    status.dwLength = sizeof(status);
    if (GlobalMemoryStatusEx(&status)) {
        unsigned int totalMemoryInMB = status.ullTotalPhys / (1024 * 1024);
        unsigned int maxQubits = getMaxQubits(totalMemoryInMB);
        std::cout << "Total RAM: " << totalMemoryInMB << " MB" << std::endl;
        std::cout << "Rounded RAM: " << roundToNearestPowerOf2(totalMemoryInMB) / 1024 << " GB" << std::endl;
        std::cout << "Max Qubits You Can Safely Simulate: " << maxQubits << std::endl;
    } else {
        std::cerr << "Failed to get memory status." << std::endl;
    }
}

#elif defined(__linux__)
#include <fstream>
#include <string>

void checkMemory() {
    std::ifstream meminfo("/proc/meminfo");
    if (!meminfo.is_open()) {
        std::cerr << "Failed to open /proc/meminfo." << std::endl;
        return;
    }

    std::string line;
    while (std::getline(meminfo, line)) {
        if (line.find("MemTotal:") == 0) {
            std::string totalMem = line.substr(line.find_first_of("0123456789"));
            unsigned int totalMemoryInKB = std::stoll(totalMem);
            unsigned int totalMemoryInMB = totalMemoryInKB / 1024;
            unsigned int maxQubits = getMaxQubits(totalMemoryInMB);
            std::cout << "Total RAM: " << totalMemoryInMB << " MB" << std::endl;
            std::cout << "Rounded RAM: " << roundToNearestPowerOf2(totalMemoryInMB) / 1024 << " GB" << std::endl;
            std::cout << "Max Qubits You Can Safely Simulate: " << maxQubits << std::endl;
            break;
        }
    }

    meminfo.close();
}

#else
void checkMemory() {
    std::cerr << "Unsupported platform." << std::endl;
}
#endif

