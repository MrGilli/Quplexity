#include <iostream> 
#include <cstdint>
extern "C" uint64_t getMemorySize();

int main(){
  uint64_t memorySize = getMemorySize();
  std::cout << "Total memory size: " << memorySize << "bytes\n";
  return 0;
}
