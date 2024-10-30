// 📅 2024-11-06 14:36:06
#include "error_handling.h"
// arpa: Advanced Research Projects Agency. Provides definitions for internet operations.
#include <arpa/inet.h>
#include <fcntl.h>
// stdio: Standard Input Output, for basic I/O operations like printf.
#include <stdio.h>
// stdlib: Standard Library, for general functions like memory allocation and process control.
#include <stdlib.h>
#include <string.h>
// sys: System, socket: Socket definitions and protocols for inter-process communication.
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
// unistd: UNIX standard, provides access to the POSIX operating system API.
#include <unistd.h>

#define BUF_SIZE 1024

// main function takes command-line arguments.
int main(int argc, char *argv[]) {
  // ▶️ Declare Socket descriptor, Socket address information, Message (Buffer Size, Message length)
  // ❔ Why client_addr_size, str_len required?
  // 📝 Answer: `client_addr_size`, `str_len` is needed because ... requires ...

  // ❔ Why Buffer Size unit is 1024??
  // 📝 Answer: A buffer size of 1024 bytes (1 KB) is commonly used as it provides a reasonable trade-off between memory usage and data throughput.
  // It's large enough to hold a typical chunk of data without excessive memory usage and aligns well with network and file system block sizes, improving performance.
  int server_sock, client_sock;
  struct sockaddr_in server_addr, client_addr;
  socklen_t client_addr_size;
  char buffer[BUF_SIZE];
  int str_len;
  // Declare variables for File copy
  int out;

  // ▶️ Validate argc, argv
  if (argc != 3) {
    printf("Usage : %s <port> <file>\n", argv[0]);
    exit(1);
  }

  // ▶️ Initialize file, socket and sockaddr_in
  // Open file with 644
  if ((out = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC,
                  S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) < 0) {
    perror(argv[3]);
    return -1;
  }

  server_sock = socket(PF_INET, SOCK_STREAM, 0);
  if (server_sock < 0) {
    perror("socket()");
    error_handling("socket() error");
  }

  memset(&server_addr, 0, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
  server_addr.sin_port = htons(atoi(argv[1]));

  // ▶️ bind(), listen(), accept()
  // ❔ Why explicit type casting to (struct sockaddr *) and sizeof(server_addr) required?
  // 📝 Answer: The `bind()` function expects a `struct sockaddr *` type for the address parameter.
  // Explicit casting helps avoid warnings and clarifies the intended structure.
  // `sizeof(server_addr)` provides the exact memory size, ensuring correct binding to the server address.
  if (bind(server_sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) <
      0) {
    error_handling("bind() error");
  }

  if (listen(server_sock, 5) == -1) {
    error_handling("listen() error");
  }

  while (1) {
    client_addr_size = sizeof(client_addr);
    // ❔ Why pass `&client_addr_size` as a pointer to `accept()`?
    // 📝 Answer: `accept()` requires a pointer for `addr_len` to update `client_addr_size` with the actual client address length upon connection.
    // This design enables the server to handle clients with variable address sizes across different address families, such as IPv4, IPv6, or UNIX sockets.
    client_sock =
        accept(server_sock, (struct sockaddr *)&client_addr, &client_addr_size);
    if (client_sock < 0) {
      perror("accept()");
      error_handling("accept() error");
    }

    printf("Client connected...\n");

    do {
      // 📝 If it is echo server and client send message by stdin inbput as fgets(), server gets message includes New Line charater.
      // if that, may be required "message[str_len] = '\0';"

      // refer to definition of read() for return value
      str_len = read(client_sock, buffer, BUF_SIZE);

      // str_len > 0: Data was successfully read
      if (str_len > 0) {
        write(out, buffer, str_len);
        printf("Read: %d\n", str_len);
      }
      // str_len == 0: Client has closed the connection
      else if (str_len == 0) {
        printf("Client disconnected.\n");
        break;
      }
      // str_len == -1: An error occurred during read
      else if (str_len == -1) {
        perror("read()");
        error_handling("read() error");
        break;
      }
    } while (str_len != 0);

    close(out);
    close(client_sock); // Close the client socket after client disconnects
    printf("Done...\n");
    break;
  }

  close(server_sock); // Close server socket
  return 0;
}

/*
❓ About socket(); creates a new socket for communication.
  - domain: `PF_INET`: 🪱 Specifies the protocol family as IPv4, indicating that the socket will use IPv4 addresses for communication.
    - This constant represents the 🪱 protocol family for IPv4, meaning it will use IPv4 as the communication method.
    - `AF_INET` generally specifies the address family within the `sockaddr` structure, while `PF_INET` indicates the protocol family used by `socket()` itself.
    - In practice, `AF_INET` and `PF_INET` are often used interchangeably, as they refer to the same address space in IPv4 networking.
  - type: `SOCK_STREAM`: 🪱 Sets the socket type to `SOCK_STREAM`, primarily used for TCP connections.
    - `SOCK_STREAM` defines a stream-based socket type, providing a reliable, connection-oriented, in-order communication channel.
    - This setup is ideal for TCP, where data integrity and order are critical requirements, enabling the socket to transmit data as a continuous byte stream.
  - protocol: `0`: The protocol is set to 0, allowing the operating system to choose the default protocol
    - By setting `protocol` to `0`, the operating system automatically selects the appropriate default protocol for the specified socket type and protocol family combination.
    - Here, it defaults to TCP for `SOCK_STREAM` in conjunction with `PF_INET` (IPv4), ensuring reliable data transfer.
  This function returns a file descriptor for the newly created socket, or `-1` if an error occurs,
  indicating that the socket could not be successfully created.

❓ About memset(); initializes a block of memory to a specified value.
  - `s` (source or start): Pointer to the starting address of the memory block to be set.
    This specifies where in memory the initialization should begin.
  - `c` (character): Value to set, which is treated as an unsigned char and copied into each byte of the specified memory block.
  - `n` (number): Number of bytes to set in the memory block. This determines how many bytes from the starting address `s` will be filled with the value `c`.


❓ About struct sockaddr_in
  Reference
    ⚓ sockaddr ; https://man7.org/linux/man-pages/man3/sockaddr.3type.html
      Internet domain sockets

  It will use the created the variable name "sin_family" by implementation
  ```cpp
    #define	__SOCKADDR_COMMON(sa_prefix) \
    sa_family_t sa_prefix##family
    struct sockaddr_in
    {
      __SOCKADDR_COMMON (sin_);
      ...
    }
  ```
  ❔ The `__SOCKADDR_COMMON` Macro:
    The `__SOCKADDR_COMMON` macro defines fields that are common to all `sockaddr` structures.
    It is used to declare the `sa_family` field with the prefix `sin_`, which becomes `sin_family` when combined.
    The `##` in `sa_prefix##family` is a preprocessor concatenation operator, allowing the macro to prepend `sin_` to `family`, forming `sin_family`.


  Explanation:
    The `struct sockaddr_in` structure is specifically designed for handling IPv4 internet addresses in network programming.
    This structure includes key fields that specify the address family, port number, and IP address.

    Key Fields in `sockaddr_in`:
    - `sin_family`: Specifies the address family allowing the socket to understand the format and nature of the address.
      In this case, `AF_INET` is used to indicate IPv4.
    - `sin_port`: Stores the port number for the socket.
      This value is stored in "network byte order" (big-endian format), as required by network protocols.
    - `sin_addr`: Stores the IP address for the socket, specifically in `sin_addr.s_addr`.

  Additional Details:
    - `AF_INET`: This constant represents the 🪱 address family for IPv4. It is used to define the `sin_family` field to ensure the socket knows it will be communicating over IPv4.
    - `INADDR_ANY`: Address to accept any incoming messages.
      This constant is used with `sin_addr.s_addr` to allow the socket to accept connections on any Internet network interface associated with the host (e.g., any available IP address).
      It is converted to network byte order using `htonl`.
    - `htons` and `htonl` (🪱 Host to Network Short/Long):
      Both functions are used to convert values from host byte order
      (which may be little-endian or big-endian depending on the machine) to network byte order (always big-endian).
      This ensures consistency across different networked systems.
    - `atoi` (🪱 ASCII to Integer): Converts a string to an integer.
      In this context, it is used to interpret the port number provided as a command-line argument and convert it from a string to an integer that can be used in `sin_port`.



📝 You must write exception code coressponding with return vlaue of functions.
❔ Why client_addr_size, str_len required?
  📝 Answer: `client_addr_size` and `str_len` are needed because, in C, pointers alone do not convey the length or size of the data they reference. 
  Functions like `accept` and `write` require explicit length information to know how much memory to read or write, ensuring safe and correct operation.
*/
