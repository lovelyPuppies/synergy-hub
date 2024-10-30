#include <stdio.h>

typedef struct {
  unsigned long size;
  unsigned char buff[3];
} test_info;
// vs     __attribute__((packed)) test_info

int main(void) {
  printf("info size :%d\n", sizeof(test_info));
  // >> 16? 8 ? 7?
}
