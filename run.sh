#!/bin/bash
clear
echo "Quplexity-ARM"

# Assemble the ARM assembly code
as -o ARM/matrix.o ARM/matrix.s
as -o ARM/gates.o ARM/gates.s
as -o ARM/complex.o ARM/complex.s
as -o ARM/math.o ARM/math.s

# Compile the C++ code and link with the assembled object file
#g++ -std=c++11 -o test CPP/main.cpp ARM/matrix.o ARM/gates.o ARM/complex.o
gcc CPP/theQ.c ARM/math.o ARM/gates.o ARM/complex.o -o test

# Run the executable
./test