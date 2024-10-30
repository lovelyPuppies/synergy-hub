// 📅 2024-11-07
#include <arpa/inet.h> // arpa: Advanced Research Projects Agency. Defines network operations for internet protocols.
#include <stdio.h> // stdio: Standard Input Output, for basic I/O operations like printf.
#include <stdlib.h> // stdlib: Standard Library, for general functions like memory allocation and process control.
#include <string.h> // string: Provides functions for manipulating C strings.
#include <sys/socket.h> // sys/socket: Definitions and protocols for socket operations, essential for inter-process communication.
#include <unistd.h> // unistd: UNIX standard, provides access to the POSIX operating system API.

#define BUF_SIZE 30 // Defines buffer size for receiving data

void error_handling(
    char *
        message); // Function prototype for error handling, outputs a message and exits.

int main(int argc, char *argv[]) {
  // ▶️ Declare socket descriptor, address information, buffer, and join address structure
  int recv_sock;           // Socket for receiving multicast data
  int str_len;             // Length of received data
  char buf[BUF_SIZE];      // Buffer for storing received messages
  struct sockaddr_in adr;  // Socket address for binding to the specified port
  struct ip_mreq join_adr; // Structure to join a multicast group

  // ▶️ Validate argc, argv (usage check)
  if (argc != 3) {
    printf("Usage : %s <GroupIP> <PORT>\n", argv[0]);
    exit(1);
  }

  // ▶️ Initialize socket and set up address for binding
  recv_sock = socket(PF_INET, SOCK_DGRAM, 0);
  memset(&adr, 0, sizeof(adr)); // Initialize address structure with zeros
  adr.sin_family = AF_INET;     // IPv4 address family
  adr.sin_addr.s_addr =
      htonl(INADDR_ANY); // Accept incoming data from any network interface
  adr.sin_port = htons(atoi(argv[2])); // Port number from the second argument

  // Bind the socket to the specified address and port
  if (bind(recv_sock, (struct sockaddr *)&adr, sizeof(adr)) == -1)
    error_handling("bind() error");

  // ▶️ Configure multicast group settings
  join_adr.imr_multiaddr.s_addr =
      inet_addr(argv[1]); // Set the multicast group address
  join_adr.imr_interface.s_addr =
      htonl(INADDR_ANY); // Use any available network interface

  // Join the multicast group to receive data
  setsockopt(recv_sock, IPPROTO_IP, IP_ADD_MEMBERSHIP, (void *)&join_adr,
             sizeof(join_adr));

  // ▶️ Receive data from multicast group in a loop
  while (1) {
    // Receive data with a maximum length of BUF_SIZE - 1 to leave space for null termination
    str_len = recvfrom(recv_sock, buf, BUF_SIZE - 1, 0, NULL, 0);

    // Check for data reception errors
    if (str_len < 0)
      break;

    // Null-terminate the received message
    buf[str_len] = 0;
    fputs(buf, stdout); // Print the message to standard output
  }

  close(recv_sock); // Close the receiving socket
  return 0;
}

/*
❓ About multicast settings and IP_ADD_MEMBERSHIP
  - `join_adr.imr_multiaddr.s_addr = inet_addr(argv[1]);`
    The multicast IP address specified by the user is set here, allowing the program to receive data directed to this multicast group.
    The address provided in `argv[1]` is converted from a dotted decimal format to a network byte order integer using `inet_addr`.

  - `join_adr.imr_interface.s_addr = htonl(INADDR_ANY);`
    This setting allows the socket to listen on all available network interfaces. It is useful for devices connected to multiple networks,
    enabling reception of multicast data across any network interface. `INADDR_ANY` is used for flexibility.

  - `setsockopt(... IP_ADD_MEMBERSHIP ...)`
    This option is essential for multicast reception, as it registers the socket to join the specified multicast group.
    By setting this option, the kernel knows that packets sent to this multicast address should be directed to this socket.

  Explanation:
    Multicast sockets must join a multicast group to receive data broadcast to that group.
    The `setsockopt()` function with `IP_ADD_MEMBERSHIP` adds the socket to the multicast group, enabling the process to receive all packets sent to this address.
    Without this step, the socket would ignore multicast packets directed to the group address.
    
    `join_adr` structure fields:
    - `imr_multiaddr`: Multicast group IP address to join, determining the group’s address.
    - `imr_interface`: Specifies the local interface through which multicast data is received; using `INADDR_ANY` allows all interfaces.
    
    This setup allows the program to receive messages sent by any multicast-capable sender within the group.
*/
