#include <iostream>
#include <vector>
#include <chrono>

extern "C" {
    void matrix2x2(int64_t* A, int64_t* B, int64_t* C);
}

void matrix2x2_cpp(const std::vector<int64_t>& A, const std::vector<int64_t>& B, std::vector<int64_t>& C) {
    C[0] = A[0] * B[0] + A[1] * B[2];
    C[1] = A[0] * B[1] + A[1] * B[3];
    C[2] = A[2] * B[0] + A[3] * B[2];
    C[3] = A[2] * B[1] + A[3] * B[3];
}

int main() {
    std::vector<int64_t> A = {1, 2, 3, 4};
    std::vector<int64_t> B = {5, 6, 7, 8};
    std::vector<int64_t> C_cpp(4, 0);
    std::vector<int64_t> C_asm(4, 0);

    // Measure time for C++ implementation
    auto start_cpp = std::chrono::high_resolution_clock::now();
    matrix2x2_cpp(A, B, C_cpp);
    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duration_cpp = end_cpp - start_cpp;

    // Measure time for assembly implementation
    auto start_asm = std::chrono::high_resolution_clock::now();
    matrix2x2(A.data(), B.data(), C_asm.data());
    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::micro> duration_asm = end_asm - start_asm;

    // Print results
    std::cout << "C++ Result: ";
    for (const auto& val : C_cpp) std::cout << val << " ";
    std::cout << "\n";

    std::cout << "Assembly Result: ";
    for (const auto& val : C_asm) std::cout << val << " ";
    std::cout << "\n";

    std::cout << "C++ Duration: " << duration_cpp.count() << " microseconds\n";
    std::cout << "Assembly Duration: " << duration_asm.count() << " microseconds\n";

    return 0;
}
