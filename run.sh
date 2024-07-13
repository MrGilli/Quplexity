clear
#cd qc

#Assembler 
cd ASM
nasm -f elf64 -o module.o module.asm
nasm -f elf64 -o memory.o memory.asm
##

cd ../compiler
g++ main.cpp ../qc/quantum.cpp ./errors.cpp ../ASM/module.o ../ASM/memory.o -o qcvm

./qcvm


cd ../
