clear

nasm -f elf64 asm_file.asm -o asm_file.o

g++ -no-pie cpp_file.cpp asm_file.o -o test

./test

