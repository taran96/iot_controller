#include "elixir_interface.h"

ElixirInterface::ElixirInterface() {
  keepRunning = true;
}

ElixirInterface::~ElixirInterface() {
  stdinThread.join();
}

void ElixirInterface::acceptMessage() {
  while (keepRunning && std::cin >> messageBuffer) {
    
  }
}


void ElixirInterface::sendMessage(string msg) {
  std::cout << msg << "\n";
}
