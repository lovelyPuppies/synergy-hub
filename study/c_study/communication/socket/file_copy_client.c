#include "error_handling.h"
#include <arpa/inet.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define BUF_SIZE 1024

int main(int argc, char *argv[]) {
  // Declare variables for Socket
  int sock;
  struct sockaddr_in server_addr;
  char buffer[BUF_SIZE];
  int str_len;
  // Declare variables for File copy
  int in;

  // Validate arguments
  if (argc != 4) {
    printf("Usage : %s <IP> <port> <file>\n", argv[0]);
    exit(1);
  }
  // Open file
  if ((in = open(argv[3], O_RDONLY)) == -1) {
    perror(argv[3]);
    return -1;
  }
  printf("File %s is opend\n", argv[3]);

  // Initialize socket
  sock = socket(PF_INET, SOCK_STREAM, 0);
  if (sock == -1) {
    perror("socket()");
    error_handling("socket() error");
  }

  memset(&server_addr, 0, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = inet_addr(argv[1]);
  server_addr.sin_port = htons(atoi(argv[2]));

  // Connect Socket
  if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) ==
      -1) {
    error_handling("connect() error!");
  }

  // Send file by unit "buffer"
  do {
    str_len = read(in, buffer, BUF_SIZE);

    // str_len > 0: Data was successfully read
    if (str_len > 0) {
      if (write(sock, buffer, str_len) == -1) {
        perror("write()");
        exit(1);
      }
      printf("Sent %d bytes ...\n", str_len);
    }
    // str_len == 0: Complete File read
    else if (str_len == 0) {
      printf("Complete File read.\n");
      break;
    }
    // str_len == -1: An error occurred during file read
    else if (str_len == -1) {
      perror("read()");
      error_handling("read() error");
      exit(1);
      break;
    }

  } while (str_len != 0);

  printf("Done ...\n");

  close(in);
  close(sock);
  return 0;
}
