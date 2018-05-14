#include <iostream>
#include <string>
#include <thread>


/* These names are chosen so that they do not interfere with macros */
enum Level {
  TRC = 0,
  DBG,
  INF,
  WRN,
  ERR,
};


enum Type {
  GETSTATE = 0,
  SENDSTATE,
};

struct ElixirRequest {
  Type type;
  size_t size;
  char * payload;
};




class ElixirInterface {

 private:
  std::thread stdinThread;
  bool keepRunning;
  std::string messageBuffer;

 public:
  ElixirInterface();
  ~ElixirInterface();

  void acceptMessage();
  void sendMessage();
  void post(Level level, std::string msg,);
};
