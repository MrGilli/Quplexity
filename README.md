[![Mentioned in Awesome - awesome-quantum-software](https://awesome.re/mentioned-badge.svg)](https://github.com/qosf/awesome-quantum-software)
![OS](https://img.shields.io/badge/os-MacOS-9cbd3c.svg)
![OS](https://img.shields.io/badge/os-Linux-9cbd3c.svg)
![OS](https://img.shields.io/badge/os-Windows-9cbd3c.svg)

# What Is Quplexity?

Quplexity is a blazingly fast and lightweight (modular) library that provides Quantum Computer (QC) simulators with their mathematical and essential quantum logic gates/functions. 
Quplexity is written in "Assembly" aka "Assembler" for very fast execution and computational times. Quplexity has exstensive and carefully crafted documentation, to help anyone no matter what their technological fluency is, to integrate Quplexity into their project or contribute to the project itself. Documentation and Examples can be found in the folder (./Documentation). Quplexity is currently in the process of being intergrated into Qrack (https://github.com/unitaryfund/qrack) to provide accelerated performance and better tailored hardware support. 

## Projects Using Quplexity
To add your project email me or submit a pull request.
* [Qrack](https://github.com/unitaryfund/qrack) - Fast Quantum Computer Simulator/Emulator.
* [LLY-DML](https://github.com/LILY-QML/LLY-DML) - Quantum Machine Learning model.
* [theQ & Quantum Quokka](https://github.com/devitt1/theQ) - Quantum Computing simulation project, By Dr. S.J. Devitt and Prof. C. Ferrie at QSI@UTS

## Getting Started!
#### Please check ./quplexity_manual.pdf (https://github.com/MrGilli/Quplexity/blob/main/quplexity_manual.pdf) to learn how to use all Quplexity functions in your C/C++ project.

### Dependencies

Install the following to build/run Quplexity on your machine: 
* nasm (for intel and x86 ASM)
* as   (for ARM/ARM64 ASM)
* gcc & g++

### Compiling and Linking!

After you installed the dependencies and ensured everything is working your ready to start using Quplexity:
###### Compiling:
```bash
nasm -f elf64 assembly_file.asm -o assembly_object_file.o
```
###### Then link with your C/C++ file:
```bash
gcc -no-pie c_file.c assembly_object_file.o -o test
```
###### To run the example above:
```bash
./test
```

## Author(s)

Jacob Gill  

contact: jacobygill@outlook.com 

Discord: @bixel0
