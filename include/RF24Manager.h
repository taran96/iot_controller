#include <memory>
#include <thread>

#include <RF24Mesh/RF24Mesh.h>
#include <RF24/RF24.h>
#include <RF24Network/RF24Network.h>


class RF24Manager {
 protected:
  std::shared_ptr<RF24> radio;
  std::shared_ptr<RF24Network> network;
  std::shared_ptr<RF24Mesh> mesh;
  std::thread meshThread;

 public:
  RF24Manager();
  ~RF24Manager();

  void startMesh();

}
