#include <iostream>

#include "proto/person.pb.h"

int main() {

  person p;
  
  p.set_id(1);
  p.set_name("jerry");

  std::cout << p.name() << std::endl;

  return 0;
}
