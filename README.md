[![Mentioned in Awesome - awesome-quantum-software](https://awesome.re/mentioned-badge.svg)](https://github.com/qosf/awesome-quantum-software)

# Quplexity

Quplexity is a blazingly fast and lightweight (modular) library that provides Quantum Computer (QC) simulators with their mathematical and essential quantum logic gates. 
Quplexity is written in "Assembly" aka "Assembler" for very fast execution and computational times. Quplexity has exstensive and carefully crafted documentation, to help anyone no matter what their technological fluency is, to integrate Quplexity into their project or contribute to the project itself. Documentation and Examples can be found in the folder (./Documentation). Quplexity is currently in the process of being intergrated into Qrack (https://github.com/unitaryfund/qrack) to provide accelerated performance and better tailored hardware support. 

## Projects Using Quplexity
To add your project email me or submit a pull request.
* [Qrack](https://github.com/unitaryfund/qrack) - Fast Quantum Computer Simulator/Emulator.
* [LLY-DML](https://github.com/LILY-QML/LLY-DML) - Quantum Machine Learning model.
* [theQ & Quantum Quokka](https://github.com/devitt1/theQ) - Quantum Computing simulation project, By Dr. S.J. Devitt and Prof. C. Ferrie at QSI@UTS

## Getting Started!

### Dependencies

Install the following to build/run Quplexity on your machine: 
* nasm (for intel ASM)
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
gcc -no-pie cpp_file.asm assembly_object_file.o -o test
```
###### To run the example above:
```bash
./test
```

#### For Extensive and indepth documentation please see the *.pdf files found in the folder/directory (./Documentation)

## Author(s)

Jacob Gill  

contact: jacobygill@outlook.com 

Discord: @mrgill0651
