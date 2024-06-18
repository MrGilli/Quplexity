clear
#cd qc

#Assembler 
cd ASM
nasm -f elf64 -o module.o module.asm
##

cd ../compiler
g++ main.cpp ../qc/quantum.cpp ../ASM/module.o -o qcvm

./qcvm


cd ../
