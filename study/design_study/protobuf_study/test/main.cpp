#include "test.pb.h"
#include <iostream>

int main(void) {
  // Build the original message
  test::Test original;
  original.set_id(0);
  original.set_name("original");

  // Serialize the original message
  int size = original.ByteSize();
  char data[size];
  original.SerializeToArray(data, size);

  // Deserialize the data into a previously initialized message
  test::Test success;
  success.set_id(1);
  success.set_name("success");
  success.ParseFromArray(data, size);
  std::cout << success.id() << ": " << success.name() << std::endl;

  // Deserialize the data into an uninitialized message
  test::Test failure;
  failure.ParseFromArray(data, size); // FAILS HERE WITH CLANG++
  std::cout << failure.id() << ": " << failure.name() << std::endl;
}