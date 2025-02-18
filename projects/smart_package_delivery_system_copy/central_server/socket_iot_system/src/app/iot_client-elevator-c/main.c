// socket_iot_system/build/linux-debug-clang-19-x86_64/iot_client_c 10.10.14.19 1234 Hello

/* =========================
 *  Includes and Definitions
 * ========================= */
// 📅 2025-02-07 05:20:22

// Library inclusions for necessary functionalities
// ⚙️ --------------------------------------------------
#include "protobuf_c/message_preparer.h"
#include "protobuf_c/smart_pkg_delivery.pb.h"
#include <pb_decode.h>
#include <pb_encode.h>
// --------------------------------------------------
#include <arpa/inet.h> // Defines functions for internet operations, such as inet_addr.
#include <pthread.h> // Includes POSIX thread support.
#include <stdbool.h>
#include <stdio.h>
#include <stdio.h>  // Standard I/O functions, like printf and fgets.
#include <stdlib.h> // Standard library functions, such as memory allocation.
#include <string.h> // String handling functions, such as memset and strcpy.
#include <sys/select.h>
#include <sys/socket.h> // Provides socket definitions and functions.
#include <sys/types.h> // Provides system data types used in socket programming.
#include <unistd.h>    // Standard UNIX functions, like close.

// Define buffer and name size limits
#define BUF_SIZE  100
#define NAME_SIZE 20

#define MSG_MAX_LEN 32 // 메시지 소스/목적지 최대 길이
// typedef struct {
//   char msg_src[MSG_MAX_LEN];
//   char msg_dest[MSG_MAX_LEN];
// } MessageInfo;

/* =========================
 *  Global Variables
 * ========================= */
// Global variables for storing the client’s name and message data
// ⚙️ --------------------------------------------------
smart_pkg_delivery_NodeType local_msg_src_type =
    smart_pkg_delivery_NodeType_UNSPECIFIED;
uint32_t local_msg_src_id = 1;
char msg[BUF_SIZE];

// 🚧❗ Assume that this executable run with Single-thread.
smart_pkg_delivery_InteractionMsg local_request_interaction_msg =
    smart_pkg_delivery_InteractionMsg_init_zero;
smart_pkg_delivery_Request *local_request_msg;
smart_pkg_delivery_InteractionMsg local_response_interaction_msg =
    smart_pkg_delivery_InteractionMsg_init_zero;
smart_pkg_delivery_Response *local_response_msg;
smart_pkg_delivery_InteractionMsg local_event_interaction_msg =
    smart_pkg_delivery_InteractionMsg_init_zero;
smart_pkg_delivery_NodeEvent *local_event_msg;

smart_pkg_delivery_InteractionMsg received_interaction_msg =
    smart_pkg_delivery_InteractionMsg_init_zero;
// --------------------------------------------------

/* =========================
 *  Function Prototypes
 * ========================= */
// Function declarations for sending, receiving for 🧵 threading, and handling errors
void *send_msg(void *arg);
void *recv_msg(void *arg);
void error_handling(char *message);

// ⚙️ --------------------------------------------------
void init_node_configuration(smart_pkg_delivery_NodeType src_type,
                             uint32_t src_id) {
  local_msg_src_type = src_type;
  local_msg_src_id = src_id;
}

// 🏗 Wrapped Factory function for Request
smart_pkg_delivery_Request *
prepare_local_request_msg(smart_pkg_delivery_InteractionMsg *interaction_msg) {
  return prepare_request_msg(interaction_msg, local_msg_src_type,
                             local_msg_src_id);
}

// 🏗 Wrapped Factory function for Response
smart_pkg_delivery_Response *
prepare_local_response_msg(smart_pkg_delivery_InteractionMsg *interaction_msg) {
  return prepare_response_msg(interaction_msg, local_msg_src_type,
                              local_msg_src_id);
}

// 🏗 Wrapped Factory function for NodeEvent
smart_pkg_delivery_NodeEvent *prepare_local_node_event_msg(
    smart_pkg_delivery_InteractionMsg *interaction_msg) {
  return prepare_node_event_msg(interaction_msg, local_msg_src_type,
                                local_msg_src_id);
}

// --------------------------------------------------

/* =========================
 *  Main Function
 * ========================= */
int main(int argc, char *argv[]) {
  // Variables for socket, server address, and thread management

  // ⚙️ --------------------------------------------------
  // 🚣 sock: file descriptor
  int sock;
  struct sockaddr_in server_address;
  pthread_t snd_thread, rcv_thread;
  void *thread_return;

  // Validate arguments to ensure the correct number are provided.
  if (argc != 4) {
    printf("Usage : %s <IP> <port> <local_src_id>\n", argv[0]);
    exit(1);
  }

  // Convert the fourth argument (id) to uint32_t
  char *endptr;
  uint32_t temp_local_msg_id = strtol(argv[3], &endptr, 10);
  // Check for conversion errors
  if (*endptr != '\0') {
    printf("Error: Invalid ID format. Must be a numeric value.\n");
    exit(1);
  }

  init_node_configuration(smart_pkg_delivery_NodeType_CLIENT_ELEVATOR,
                          temp_local_msg_id);

  // Assign the client name from command line arguments.
  // sprintf(local_msg_source_name, "%s", argv[3]);
  // --------------------------------------------------

  // 🎱
  // Create a socket with IPv4 (PF_INET: Protocol Family Internet) and TCP (SOCK_STREAM: Stream Socket) specifications.
  // The '0' value automatically selects the appropriate protocol for the socket type:
  //    SOCK_STREAM selects TCP (Transmission Control Protocol) by default, while SOCK_DGRAM selects UDP (User Datagram Protocol) by default.
  sock = socket(PF_INET, SOCK_STREAM, 0);
  if (sock == -1)
    error_handling("socket() error");

  // Initialize the serv_addr structure to zero and set server info.
  memset(&server_address, 0, sizeof(server_address));
  server_address.sin_family = AF_INET;
  // 🚣 inet_addr: Convert Internet host address from numbers-and-dots notation in CP into binary data in 🚣 network byte order.
  server_address.sin_addr.s_addr = inet_addr(argv[1]);
  server_address.sin_port = htons(atoi(argv[2]));

  // Connect to the server, exit on failure.
  // 💡 Cast sockaddr_in to sockaddr because connect() expects a sockaddr pointer. No data change in memory, only type casting is performed.
  if (connect(sock, (struct sockaddr *)&server_address,
              sizeof(server_address)) == -1)
    error_handling("connect() error");

  // Send initial message with client name for authentication.
  // sprintf(msg, "[%s:PASSWD]", local_msg_source_name);
  // write(sock, msg, strlen(msg));

  // Create threads for handling message send and receive.
  // 💡 Cast &sock to (void*) for passing as a thread argument, no data change, only type casting.
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
  // 🌀 Declare variables for nanoPB
  uint8_t buffer[256];
  size_t msg_length;
  bool status;

  // Extract the socket descriptor from the argument
  int *sock = (int *)arg;

  // File descriptor sets for select() and timeout settings
  fd_set initset, newset;
  struct timeval tv;
  char name_msg[NAME_SIZE + BUF_SIZE + 2];

  // 📍 fd_set (File Descriptor Set) is a bitmask-based structure that tracks multiple file descriptors
  // Each bit in fd_set represents a file descriptor (FD)
  // Example representation:
  // [ 0 1 2 3 4 5 6 7 ... ]
  // [ 1 0 0 1 0 0 0 0 ... ]  // FD 0(STDIN) and 3(sock) are being monitored

  // Initialize fd_set and add standard input (keyboard) to the set
  FD_ZERO(&initset);              // Clear fd_set to remove any garbage values
  FD_SET(STDIN_FILENO, &initset); // Add stdin (keyboard input) to the set

  // Prompt the user for input format
  fputs("Input a message! [ID]msg (Default ID:ALLMSG)\n", stdout);

  while (1) {
    // Clear buffers before use
    memset(msg, 0, sizeof(msg));
    name_msg[0] = '\0';

    // Set timeout for select() - 1 second
    tv.tv_sec = 1;
    tv.tv_usec = 0;

    // 🔥 `select()` modifies `fd_set`, so always copy `initset` to `newset` before calling it
    newset = initset;
    // Example before `select()`:
    // [ 0 1 2 3 4 5 6 7 ... ]
    // [ 1 0 0 1 0 0 0 0 ... ]  // FD 0(STDIN) and 3(sock) are set

    // 💡 Wait for input with a timeout
    int ret = select(STDIN_FILENO + 1, &newset, NULL, NULL, &tv);
    // 🪱 nfds is just "max FD + 1"; the actual set of monitored FDs is determined by fd_set.
    // 🔥 select() modifies `newset`, keeping only FDs that have input available
    // If input is detected:
    // [ 0 1 2 3 4 5 6 7 ... ]
    // [ 1 0 0 0 0 0 0 0 ... ]  // FD 3 (socket) was removed since no input
    // If no input is detected (timeout occurs):
    // `select()` returns 0, and `newset` is emptied

    // Check if the standard input (keyboard) has data ready to be read
    if (FD_ISSET(STDIN_FILENO, &newset)) {
      // 🔥 `FD_ISSET(fd, &set)` checks if the given FD has input ready
      // Only FDs that had input remain in `newset`
      fgets(msg, BUF_SIZE, stdin);

      // If "quit" command is detected, close the connection.
      if (!strncmp(msg, "quit\n", 5)) {
        *sock = -1;
        return NULL;
      } else {
        strcpy(name_msg, msg);
      }

      // ⚙️📰
      local_event_msg =
          prepare_local_node_event_msg(&local_event_interaction_msg);
      local_event_msg->dest_type =
          smart_pkg_delivery_NodeType_CLIENT_DELIVERY_ROBOT;
      local_event_msg->which_event_type =
          smart_pkg_delivery_NodeEvent_elevator_status_event_tag;

      local_event_msg->event_type.elevator_status_event =
          (smart_pkg_delivery_ElevatorStatusEvent){
              .has_elevator_id = true,
              .elevator_id = 5,
              .has_elevator_status = true,
              .elevator_status.has_door_open_status = true,
              .elevator_status.door_open_status =
                  smart_pkg_delivery_Elevator_DoorOpenStatus_OPEN,
              .elevator_status.has_current_floor = true,
              .elevator_status.current_floor = 10,
          };

      pb_ostream_t stream = pb_ostream_from_buffer(buffer, sizeof(buffer));
      status = pb_encode(&stream, smart_pkg_delivery_InteractionMsg_fields,
                         &local_event_interaction_msg);
      msg_length = stream.bytes_written;
      printf("Encoded msg length: %zu \n", msg_length);

      // Send the message to the server, exit on failure.
      // if (write(*sock, name_msg, strlen(name_msg)) <= 0) {
      if (write(*sock, buffer, msg_length) <= 0) {
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
  // 🌀 Declare variables for nanoPB
  uint8_t buffer[256];
  size_t msg_length;
  bool status;

  // Variable definitions for receiving messages
  int *sock = (int *)arg;

  // Loop to continuously receive messages from server.
  while (1) {
    // For testing decoding
    // Clear the receive buffer and read message from server.
    memset(buffer, 0x0, sizeof(buffer));
    memset(&received_interaction_msg, 0,
           sizeof(smart_pkg_delivery_InteractionMsg));
    msg_length = read(*sock, buffer, NAME_SIZE + BUF_SIZE);

    pb_istream_t stream = pb_istream_from_buffer(buffer, msg_length);

    /* Now we are ready to decode the message. */
    status = pb_decode(&stream, smart_pkg_delivery_InteractionMsg_fields,
                       &received_interaction_msg);

    /* Check for errors... */
    if (!status) {
      printf("Decoding failed: %s\n", PB_GET_ERROR(&stream));
    }

    printf("\n🛠️  Debug: Received message\n");
    switch (received_interaction_msg.which_msg_type) {
    case smart_pkg_delivery_InteractionMsg_node_event_tag:
      printf("  Node Event:\n");
      printf("    Source ID: %d\n",
             received_interaction_msg.msg_type.node_event.src_id);
      printf("    Event Type: %d\n",
             received_interaction_msg.msg_type.node_event.which_event_type);
      break;

    case smart_pkg_delivery_InteractionMsg_request_tag:
      printf("  Request:\n");
      printf("    Source ID: %d\n",
             received_interaction_msg.msg_type.request.src_id);
      printf("    Event Type: %d\n",
             received_interaction_msg.msg_type.request.which_request_type);
      break;

    case smart_pkg_delivery_InteractionMsg_response_tag:
      printf("  Response:\n");
      printf("    Source ID: %d\n",
             received_interaction_msg.msg_type.response.src_id);
      printf("    Ack Status code: %d\n",
             received_interaction_msg.msg_type.response.ack_status.status_code);
      printf("    Execution Status code: %d\n",
             received_interaction_msg.msg_type.response.execution_status
                 .status_code);
      printf("    Response Type: %d\n",
             received_interaction_msg.msg_type.response.which_response_type);
      switch (received_interaction_msg.msg_type.response.which_response_type) {
      case smart_pkg_delivery_Response_move_delivery_robot_response_tag:
        break;
      default:
        break;
      }
      break;

    default:
      printf("  Unknown message type!\n");
      break;
    }
    // smart_pkg_delivery_AptAddress *address =
    //     &local_node_event_msg.event_type.pkg_arrival_event.address;
    // /* Print the data contained in the message. */
    // printf("Received address: %d동 %d호\n", address->building_num,
    //        address->unit_num);
    // printf("received msg src, dst: %d, %d!\n", local_node_event_msg.src_type,
    //        local_node_event_msg.src_id);

    // 🚣 If read() returns 0 (EOF (socket closed)) or an error occurs, mark socket as closed and exit.
    if (msg_length <= 0) {
      *sock = -1;
      return NULL;
    }

    // Null-terminate message and print it to console.
    buffer[msg_length] = 0;
    // fputs(buffer, stdout);
  }
}

// Function to handle errors.
void error_handling(char *message) {
  // Outputs error message to standard error.
  fputs(message, stderr);
  // Adds newline character to error output.
  fputc('\n', stderr);
  // Terminates program after error.
  exit(1);
}
