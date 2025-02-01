#include "message.pb.h"
#include <pb_encode.h>

int main() {
  test_Example mymessage = {42};
  uint8_t buffer[10];
  pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
  pb_encode(&stream, test_Example_fields, &mymessage);
}