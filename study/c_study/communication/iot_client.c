/* =========================
 *  Includes and Definitions
 * ========================= */
// 📅 2024-11-06 14:36:06

// Library inclusions for necessary functionalities
#include <arpa/inet.h> // Defines functions for internet operations, such as inet_addr.
#include <pthread.h> // Includes POSIX thread support.
#include <stdio.h>   // Standard I/O functions, like printf and fgets.
#include <stdlib.h>  // Standard library functions, such as memory allocation.
#include <string.h>  // String handling functions, such as memset and strcpy.
#include <sys/select.h>
#include <sys/socket.h> // Provides socket definitions and functions.
#include <sys/types.h> // Provides system data types used in socket programming.
#include <unistd.h>    // Standard UNIX functions, like close.

// Define buffer and name size limits
#define BUF_SIZE  100
#define NAME_SIZE 20
#define ARR_CNT   5

/* =========================
 *  Global Variables
 * ========================= */
// Global variables for storing the client’s name and message data
char name[NAME_SIZE] = "[Default]";
char msg[BUF_SIZE];

/* =========================
 *  Function Prototypes
 * ========================= */
// Function declarations for sending, receiving, and handling errors
void *send_msg(void *arg);
void *recv_msg(void *arg);
void error_handling(char *message);

/* =========================
 *  Main Function
 * ========================= */
int main(int argc, char *argv[]) {
  // Variables for socket, server address, and thread management
  int sock;
  struct sockaddr_in serv_addr;
  pthread_t snd_thread, rcv_thread;
  void *thread_return;

  // Validate arguments to ensure the correct number are provided.
  if (argc != 4) {
    printf("Usage : %s <IP> <port> <name>\n", argv[0]);
    exit(1);
  }

  // Assign the client name from command line arguments.
  sprintf(name, "%s", argv[3]);

  // Create a socket with IPv4 and TCP specifications.
  sock = socket(PF_INET, SOCK_STREAM, 0);
  if (sock == -1)
    error_handling("socket() error");

  // Initialize the serv_addr structure to zero and set server info.
  memset(&serv_addr, 0, sizeof(serv_addr));
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = inet_addr(argv[1]);
  serv_addr.sin_port = htons(atoi(argv[2]));

  // Connect to the server, exit on failure.
  if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) == -1)
    error_handling("connect() error");

  // Send initial message with client name for authentication.
  sprintf(msg, "[%s:PASSWD]", name);
  write(sock, msg, strlen(msg));

  // Create threads for handling message send and receive.
  pthread_create(&rcv_thread, NULL, recv_msg, (void *)&sock);
  pthread_create(&snd_thread, NULL, send_msg, (void *)&sock);

  // Wait for the send thread to finish and then close the socket.
  pthread_join(snd_thread, &thread_return);
  close(sock);
  return 0;
}

/* =========================
 *  Helper Functions
 * ========================= */
// ---- Send Message Function ----
void *send_msg(void *arg) {
  // Variable definitions for socket, file descriptors, and timeouts
  int *sock = (int *)arg;
  fd_set initset, newset;
  struct timeval tv;
  char name_msg[NAME_SIZE + BUF_SIZE + 2];

  // Initialize the file descriptor set and add standard input to it.
  FD_ZERO(&initset);
  FD_SET(STDIN_FILENO, &initset);

  // Prompt the user for input
  fputs("Input a message! [ID]msg (Default ID:ALLMSG)\n", stdout);
  while (1) {
    // Clear buffers before use
    memset(msg, 0, sizeof(msg));
    name_msg[0] = '\0';
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    // Set new file descriptor set for select call and wait for input.
    newset = initset;
    int ret = select(STDIN_FILENO + 1, &newset, NULL, NULL, &tv);

    // Check if input is available from stdin (user).
    if (FD_ISSET(STDIN_FILENO, &newset)) {
      fgets(msg, BUF_SIZE, stdin);

      // If "quit" command is detected, close the connection.
      if (!strncmp(msg, "quit\n", 5)) {
        *sock = -1;
        return NULL;
      } else if (msg[0] != '[') {
        strcat(name_msg, "[ALLMSG]");
        strcat(name_msg, msg);
      } else
        strcpy(name_msg, msg);

      // Send the message to the server, exit on failure.
      if (write(*sock, name_msg, strlen(name_msg)) <= 0) {
        *sock = -1;
        return NULL;
      }
    }
    // Exit if timeout and socket is closed
    if (ret == 0 && *sock == -1)
      return NULL;
  }
}

// ---- Receive Message Function ----
void *recv_msg(void *arg) {
  // Variable definitions for receiving messages
  int *sock = (int *)arg;
  char name_msg[NAME_SIZE + BUF_SIZE + 1];

  // Loop to continuously receive messages from server.
  while (1) {
    // Clear the receive buffer and read message from server.
    memset(name_msg, 0x0, sizeof(name_msg));
    int str_len = read(*sock, name_msg, NAME_SIZE + BUF_SIZE);

    // If no data is received, set socket to -1 and exit.
    if (str_len <= 0) {
      *sock = -1;
      return NULL;
    }

    // Null-terminate message and print it to console.
    name_msg[str_len] = 0;
    fputs(name_msg, stdout);
  }
}
