clear
#cd qc
cd compiler
gcc main.c ../qc/quantum.c -o quantum_sim -lm
./quantum_sim
cd ../
