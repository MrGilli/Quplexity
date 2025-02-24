[![Mentioned in Awesome - awesome-quantum-software](https://awesome.re/mentioned-badge.svg)](https://github.com/qosf/awesome-quantum-software)
![OS](https://img.shields.io/badge/os-MacOS-9cbd3c.svg)
![OS](https://img.shields.io/badge/os-Linux-9cbd3c.svg)
![OS](https://img.shields.io/badge/os-Windows-9cbd3c.svg)

# Quplex

Quplexity is a blazingly fast and lightweight (modular) library that provides Quantum Computer simulators with their mathematical and essential quantum logic gates or functions. Quplexity is written in x86 and ARM64(Aarch64) Assembly for fast execution and computational times. The library can significantly enhance the speed of Quantum Computer simulators, as a result of this, more complex algorithms and sequences can be simulated in an efficient yet accurate manner. Quplexity has exstensive and carefully crafted documentation, to help anyone no matter what their technological fluency is, to integrate Quplexity into their project or contribute to the project itself.

## 📌 Features
- **Optimized for Performance**: Written in low-level Assembly for maximum efficiency.
- **Cross-Architecture Support**: Supports both x86 and ARM64 architectures.
- **Modular Design**: Easily extendable for different quantum algorithms.
- **Comprehensive Documentation**: Includes manuals and examples for ease of use.

## 📥 Installation
#### Please check [Quplexity's pdf manual](https://github.com/MrGilli/Quplexity/blob/main/quplexity_manual.pdf) to learn how to use all Quplexity functions in your C/C++ project.

### 🔹 Prerequisites
Ensure the following dependencies are installed **before** building or running Quplex:
- **nasm** → for Intel and x86 Assembly.
- **as** → for ARM/ARM64 Assembly.
- **gcc & g++** → for compiling C/C++ code.
- **git** (optional) → for version control.

### 🔹 Compilation and Linking

###### Compile Assembly Code:
```bash
nasm -f elf64 assembly_file.asm -o assembly_object_file.o
```
###### Link with your C/C++ file:
```bash
gcc -no-pie c_file.c assembly_object_file.o -o test
```
###### Run:
```bash
./test
```

## 🚀 Projects Using Quplexity
To add your project, email me or submit a pull request.
* [Qrack](https://github.com/unitaryfund/qrack) - Fast Quantum Computer Simulator/Emulator.
* [LLY-DML](https://github.com/LILY-QML/LLY-DML) - Quantum Machine Learning model.
* [theQ & Quantum Quokka](https://github.com/devitt1/theQ) - Quantum Computing simulation project, By Dr. S.J. Devitt and Prof. C. Ferrie at QSI@UTS


## 🧪 Quplexity Algorithm Examples:
The Quplexity library has many examples and tests to ensure that its implemented and functioning as it should be. All examples are located in the ./Examples folder.
The directory ./Examples/x86 holds all the examples that will run on machines using the x86 architecture. Conversely, the directory ./Examples/ARM64 holds all the examples that will run on machines using the ARM64/Aarch64 architecture. 

### Running the Grovers-Search Algorithm for x86:
In the root directory of the Quplexity project, run the following commands
```bash
nasm -f elf64 ./x86/gates.asm -o ./x86/gates.o
gcc -no-pie ./Examples/x86/Grovers-Search_algorithm.c ./x86/gates.o -o grovers_search_test
./grovers_search_test
```
The output should indicate whether the state |1> or |0> is most likely. 

## Author(s)
* Jacob Gill {Founder & Lead developer} (Contact: Email = jacobygill@outlook.com, Discord = @bixel0) 
* Gabriella Xenia Talarico {Lead developer} (Contact: Discord = @gabriellaxenia19)
