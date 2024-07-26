#include <iostream>
#include <vector>
#include <array>

extern "C" {
    void gills_inv_matrix2x2(double* num1, double* num2, double* num3, double* num4, double* out_matrix);
    void gills_matrix2x2(double matrixA[2][2], double matrixB[2][2], double matrixC[2][2]);
    void gills_matrix2x1(double matrixA[2], double matrixB[2], double matrixC[1]);
    void gills_hadamard2x1(double target_matrix2x1[2], double output[2]);
}

int main() {
    std::array<double, 2> A = {1.0, 0.0};
    std::array<double, 2> B = {10.0, 299.0};
    std::array<double, 1> C = {0.0};
    std::array<double, 2> Cx2x1 = {0.0, 0.0};
    double matrixA[2][2] = {{8.0, 5.0}, {2.0, 3.0}};
    double matrixB[2][2] = {{19.0, 1.0}, {0.1, 4.0}};
    double matrixC[2][2] = {{0.0, 0.0}, {0.0, 0.0}};
    double num1 = 1.0;
    double num2 = 2.0;
    double num3 = 3.0;
    double num4 = 4.0;
    double out_matrix[4] = {0.0, 0.0, 0.0, 0.0};

    gills_inv_matrix2x2(&num1, &num2, &num3, &num4, out_matrix);

    std::cout << "Inverted matrix:" << std::endl;
    std::cout << out_matrix[0] << " " << out_matrix[1] << std::endl;
    std::cout << out_matrix[2] << " " << out_matrix[3] << "\n\n";

    gills_matrix2x2(matrixA, matrixB, matrixC);

    std::cout << "MUL two 2x2 Matrix:" << std::endl;
    std::cout << matrixC[0][0] << " " << matrixC[0][1] << std::endl;
    std::cout << matrixC[1][0] << " " << matrixC[1][1] << "\n\n";

    std::cout << "MUL two 2x1 Matrix:" << std::endl;
    gills_matrix2x1(A.data(), B.data(), C.data());
    std::cout << "[" << C[0] << "]" << "\n\n";

    std::cout << "Hadamard gate of a 2x1 Matrix:" << std::endl;
    gills_hadamard2x1(A.data(), Cx2x1.data());
    std::cout << "[" << Cx2x1[0] << "]" << "\n" << "[" << Cx2x1[1] << "]" << "\n";

    return 0;
}