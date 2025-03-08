// 📅 2024-11-07 15:30:00
#include <arpa/inet.h>
// Provides internet protocol definitions for address manipulation.
#include <stdio.h>
// Standard Input Output for basic I/O operations like printf.
#include <stdlib.h>
// Standard Library for functions like memory allocation and process control.
#include <string.h>
// String manipulation functions for handling character arrays.
#include <sys/select.h>
// Provides select() for monitoring multiple file descriptors.
#include <sys/socket.h>
// Socket definitions and protocols for inter-process communication.
#include <sys/time.h>
// For setting time intervals and timers used with select().
#include <unistd.h>
// Provides access to the POSIX operating system API.

#define BUF_SIZE 100
void error_handling(char *buf);

int main(int argc, char *argv[]) {
  int serv_sock, clnt_sock;
  struct sockaddr_in serv_adr, clnt_adr;
  struct timeval timeout;
  fd_set reads, cpy_reads;

  socklen_t adr_sz;
  int fd_max, str_len, fd_num, i;
  char buf[BUF_SIZE];

  // ▶️ Validate argc, argv
  if (argc != 2) {
    printf("Usage : %s <port>\n", argv[0]);
    exit(1);
  }

  // ▶️ Initialize server socket and address structure
  serv_sock = socket(PF_INET, SOCK_STREAM, 0);
  if (serv_sock < 0) {
    perror("socket()");
    error_handling("socket() error");
  }

  memset(&serv_adr, 0, sizeof(serv_adr));
  serv_adr.sin_family = AF_INET;
  serv_adr.sin_addr.s_addr = htonl(INADDR_ANY);
  serv_adr.sin_port = htons(atoi(argv[1]));

  // ▶️ bind(), listen()
  if (bind(serv_sock, (struct sockaddr *)&serv_adr, sizeof(serv_adr)) == -1)
    error_handling("bind() error");

  if (listen(serv_sock, 5) == -1)
    error_handling("listen() error");

  // ▶️ Initialize fd_set and set server socket
  FD_ZERO(&reads);
  FD_SET(serv_sock, &reads);
  fd_max = serv_sock;

  // ▶️ Main server loop to handle connections and messages
  while (1) {
    cpy_reads = reads;
    timeout.tv_sec = 5;
    timeout.tv_usec = 5000;

    // ❔ Why use cpy_reads instead of reads directly?
    // 📝 Answer: select() modifies the passed fd_set, so using a copy (cpy_reads) preserves the original set of file descriptors in reads for reuse.

    if ((fd_num = select(fd_max + 1, &cpy_reads, 0, 0, &timeout)) == -1)
      break;

    if (fd_num == 0)
      continue;

    // ▶️ Loop through file descriptors to check for events
    for (i = 0; i < fd_max + 1; i++) {
      if (FD_ISSET(i, &cpy_reads)) {
        if (i == serv_sock) { // connection request!
          adr_sz = sizeof(clnt_adr);
          clnt_sock = accept(serv_sock, (struct sockaddr *)&clnt_adr, &adr_sz);
          if (clnt_sock < 0) {
            perror("accept()");
            error_handling("accept() error");
          }

          FD_SET(clnt_sock, &reads);
          if (fd_max < clnt_sock)
            fd_max = clnt_sock;
          printf("connected client: %d \n", clnt_sock);

        } else { // read message!
          str_len = read(i, buf, BUF_SIZE);
          if (str_len == 0) { // close request!
            FD_CLR(i, &reads);
            close(i);
            printf("closed client: %d \n", i);
          } else {
            write(i, buf, str_len); // echo!
          }
        }
      }
    }
  }
  close(serv_sock);
  return 0;
}

// Function for error handling
void error_handling(char *buf) {
  fputs(buf, stderr);
  fputc('\n', stderr);
  exit(1);
}

/*
❓ About select(); monitors multiple file descriptors for events.
  - Select() allows a program to monitor multiple file descriptors (like sockets) at once, waiting for any of them to become ready for I/O.
  - When a file descriptor is ready (e.g., for reading or writing), select() returns, enabling non-blocking communication with multiple clients.
  - Parameters:
    - nfds: The highest-numbered file descriptor +1, defining the range of descriptors to check.
    - readfds: The fd_set structure to monitor for readability.
    - writefds, exceptfds: fd_set structures to monitor for writability and exceptions (null if unused).
    - timeout: Defines the maximum time select() will wait for an event (0 for immediate return, NULL for indefinite wait).

❓ About fd_set and related macros
  - FD_ZERO(&reads): Clears all file descriptors in reads, preparing for a fresh set.
  - FD_SET(fd, &reads): Adds a specific file descriptor to reads, marking it to be monitored.
  - FD_CLR(fd, &reads): Removes a file descriptor from reads, stopping its monitoring.
  - FD_ISSET(fd, &cpy_reads): Checks if the fd in cpy_reads is ready for an event.

Explanation:
  - `FD_ZERO` initializes a blank file descriptor set.
  - `FD_SET` adds descriptors to be monitored.
  - `select()` modifies cpy_reads to reflect only those descriptors ready for action.

❓ Why timeout with timeval (5 sec, 5000 usec)?
  - The timeout structure (5 sec, 5000 microseconds) defines how long select() will wait for any activity. Setting a finite timeout avoids indefinite blocking, allowing the program to periodically check other processes or terminate gracefully if needed.

❓ About struct timeval
  - `tv_sec` and `tv_usec` specify time in seconds and microseconds, respectively.
  - Setting timeout ensures the program checks for events periodically.

❓ Why maintain fd_max?
  - `fd_max` is necessary because select() only checks up to the highest numbered file descriptor. Updating fd_max ensures all active descriptors are monitored, expanding as new clients connect.

fd_set와 select()를 이용한 다중 클라이언트 서버는 비동기적 연결 요청을 관리하며 동시에 여러 클라이언트와 통신을 제공합니다.
*/
