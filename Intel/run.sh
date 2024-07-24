clear

nasm -f elf64 utility.asm -o utility.o

g++ -no-pie a.cpp utility.o -o test

./test

