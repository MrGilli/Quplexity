clear
echo "Quplexity-x86"

nasm -f elf64 ./x86/gates.asm -o ./x86/gates.o
gcc -no-pie -z noexecstack ./x86/main.c ./x86/gates.o -o main -lm

./main
