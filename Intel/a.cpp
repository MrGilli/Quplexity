/*
#include <iostream>
#include <cmath>
#include <vector>
#include <chrono>
#include <cmath>

extern "C" {
    void sqrt_array_asm(float* input, float* output, std::size_t count);
    float floatingpoint_sqrt(float num);
    float fast_inverse_sqrt(float num);
}

void sqrt_array_cpp(const std::vector<float>& input, std::vector<float>& output) {
    for (std::size_t i = 0; i < input.size(); ++i) {
        output[i] = std::sqrt(input[i]);
    }
}

int main() {
    const std::size_t size = 1000000;
    std::vector<float> input(size);
    std::vector<float> output_cpp(size);
    std::vector<float> output_asm(size);

    // Initialize input data
    for (std::size_t i = 0; i < size; ++i) {
        input[i] = static_cast<float>(i + 1);
    }

    // Measure time for C++ implementation
    auto start_cpp = std::chrono::high_resolution_clock::now();
    sqrt_array_cpp(input, output_cpp);
    auto end_cpp = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration_cpp = end_cpp - start_cpp;

    // Calculate sum of square roots for C++ implementation
    float sum_cpp = 0.0f;
    for (const auto& val : output_cpp) {
        sum_cpp += val;
    }

    // Measure time for assembly implementation
    auto start_asm = std::chrono::high_resolution_clock::now();
    sqrt_array_asm(input.data(), output_asm.data(), size);
    auto end_asm = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration_asm = end_asm - start_asm;

    // Calculate sum of square roots for assembly implementation
    float sum_asm = 0.0f;
    for (const auto& val : output_asm) {
        sum_asm += val;
    }

    // Verify results
    bool match = true;
    for (std::size_t i = 0; i < size; ++i) {
        if (output_cpp[i] != output_asm[i]) {
            match = false;
            break;
        }
    }

    if (match) {
        std::cout << "Results match!" << std::endl;
    } else {
        std::cout << "Results do not match!" << std::endl;
    }

    std::cout << "C++ time: " << duration_cpp.count() << " ms" << std::endl;
    std::cout << "Assembly time: " << duration_asm.count() << " ms" << std::endl;
    std::cout << "Sum of square roots (C++): " << sum_cpp << std::endl;
    std::cout << "Sum of square roots (Assembly): " << sum_asm << std::endl;

    std::cout << std::endl << "Inverse Square Root Assembly: " << std::endl;
    
    auto start_asm1 = std::chrono::high_resolution_clock::now();
    float sqrt_ans = fast_inverse_sqrt(20.28865f);
    auto end_asm1 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration_asm1 = end_asm1 - start_asm1;
    std::cout << "Inverse square root (Assembly): " << sqrt_ans << std::endl;
    std::cout << "Assembly floating square root time: " << duration_asm1.count() << " ms" << std::endl;


    std::cout << std::endl << "Inverse Square Root C++: " << std::endl;

    auto start_cpp1 = std::chrono::high_resolution_clock::now();

    float cpp_inverse_sqrt = 1.0f / std::sqrt(20.28865f);
    

    auto end_cpp1 = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::milli> duration_cpp1 = end_cpp1 - start_cpp1;
    std::cout << "Inverse square root (C++): " << cpp_inverse_sqrt << std::endl;
    std::cout << "C++ floating square root time: " << duration_cpp1.count() << " ms" << std::endl;

    return 0;
}

*/
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
