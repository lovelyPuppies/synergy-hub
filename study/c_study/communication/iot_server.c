// Library inclusions for necessary functionalities
#include <arpa/inet.h>  // Internet operations and functions
#include <dirent.h>     // Directory handling functions
#include <errno.h>      // Error handling definitions
#include <fcntl.h>      // File control operations
#include <netinet/in.h> // Structures and macros for internet addresses
#include <pthread.h>    // POSIX thread support
#include <stdio.h>      // Standard I/O functions
#include <stdlib.h>     // Standard library functions, like memory allocation
#include <string.h>     // String handling functions
#include <sys/socket.h> // Socket definitions and functions
#include <sys/stat.h>   // File status functions
#include <sys/time.h>   // Time functions for handling timeouts
#include <sys/types.h>  // System data types for socket programming
#include <time.h>       // Standard time library
#include <unistd.h>     // Standard UNIX functions, like close

// Buffer and size definitions
#define BUF_SIZE 100
#define MAX_CLNT 32
#define ID_SIZE  10
#define ARR_CNT  5

// Debugging mode
#define DEBUG

// Message information structure
typedef struct {
  char fd;
  char *from;
  char *to;
  char *msg;
  int len;
} MSG_INFO;

// Client information structure
typedef struct {
  int index;
  int fd;
  char ip[20];
  char id[ID_SIZE];
  char pw[ID_SIZE];
} CLIENT_INFO;

// Function declarations for client connection handling, message sending, error handling, and logging
void *clnt_connection(void *arg);
void send_msg(MSG_INFO *msg_info, CLIENT_INFO *first_client_info);
void error_handling(char *message);
void log_file(char *msgstr);

// Global variables
int clnt_cnt = 0;
pthread_mutex_t mutx;

int main(int argc, char *argv[]) {
  // Variables for server and client sockets, server address, and client management
  int serv_sock, clnt_sock;
  struct sockaddr_in serv_adr, clnt_adr;
  socklen_t clnt_adr_sz;
  int sock_option = 1;
  pthread_t t_id[MAX_CLNT] = {0};
  int str_len = 0;
  int i;
  char idpasswd[(ID_SIZE * 2) + 3];
  char *pToken;
  char *pArray[ARR_CNT] = {0};
  char msg[BUF_SIZE];

  // Initialize client information array with default data
  CLIENT_INFO client_info[MAX_CLNT] = {
      {0, -1, "", "KSH_ARD", "PASSWD"}, {0, -1, "", "2", "PASSWD"},
      {0, -1, "", "3", "PASSWD"},       {0, -1, "", "4", "PASSWD"},
      {0, -1, "", "5", "PASSWD"},       {0, -1, "", "6", "PASSWD"},
      {0, -1, "", "7", "PASSWD"},       {0, -1, "", "8", "PASSWD"},
      {0, -1, "", "9", "PASSWD"},       {0, -1, "", "10", "PASSWD"},
      // ... continued initialization for all client slots
  };

  // Argument validation for port input
  if (argc != 2) {
    printf("Usage : %s <port>\n", argv[0]);
    exit(1);
  }
  fputs("IoT Server Start!!\n", stdout);

  // Initialize mutex for synchronized access
  if (pthread_mutex_init(&mutx, NULL))
    error_handling("mutex init error");

  // Create a socket with IPv4 and TCP specifications
  serv_sock = socket(PF_INET, SOCK_STREAM, 0);

  // Initialize server address structure
  memset(&serv_adr, 0, sizeof(serv_adr));
  serv_adr.sin_family = AF_INET;
  serv_adr.sin_addr.s_addr = htonl(INADDR_ANY);
  serv_adr.sin_port = htons(atoi(argv[1]));

  // Set socket options to reuse address
  setsockopt(serv_sock, SOL_SOCKET, SO_REUSEADDR, (void *)&sock_option,
             sizeof(sock_option));

  // Bind socket to server address and start listening
  if (bind(serv_sock, (struct sockaddr *)&serv_adr, sizeof(serv_adr)) == -1)
    error_handling("bind() error");
  if (listen(serv_sock, 5) == -1)
    error_handling("listen() error");

  // Main loop to handle incoming client connections
  while (1) {
    clnt_adr_sz = sizeof(clnt_adr);
    clnt_sock = accept(serv_sock, (struct sockaddr *)&clnt_adr, &clnt_adr_sz);

    // Check for client limit
    if (clnt_cnt >= MAX_CLNT) {
      printf("socket full\n");
      shutdown(clnt_sock, SHUT_WR);
      continue;
    } else if (clnt_sock < 0) {
      perror("accept()");
      continue;
    }

    // Handle client authentication
    str_len = read(clnt_sock, idpasswd, sizeof(idpasswd));
    idpasswd[str_len] = '\0';

    if (str_len > 0) {
      i = 0;
      pToken = strtok(idpasswd, "[:]");

      // Parse received data
      while (pToken != NULL) {
        pArray[i] = pToken;
        if (i++ >= ARR_CNT)
          break;
        pToken = strtok(NULL, "[:]");
      }
      // Check client information and authenticate
      for (i = 0; i < MAX_CLNT; i++) {
        if (!strcmp(client_info[i].id, pArray[0])) {
          // Handle already logged-in clients
          if (client_info[i].fd != -1) {
            sprintf(msg, "[%s] Already logged!\n", pArray[0]);
            write(clnt_sock, msg, strlen(msg));
            log_file(msg);
            shutdown(clnt_sock, SHUT_WR);
#if 1 // for MCU
            client_info[i].fd = -1;
#endif
            break;
          }
          // Authenticate client and create connection thread
          if (!strcmp(client_info[i].pw, pArray[1])) {
            strcpy(client_info[i].ip, inet_ntoa(clnt_adr.sin_addr));
            pthread_mutex_lock(&mutx);
            client_info[i].index = i;
            client_info[i].fd = clnt_sock;
            clnt_cnt++;
            pthread_mutex_unlock(&mutx);
            sprintf(msg, "[%s] New connected! (ip:%s,fd:%d,sockcnt:%d)\n",
                    pArray[0], inet_ntoa(clnt_adr.sin_addr), clnt_sock,
                    clnt_cnt);
            log_file(msg);
            write(clnt_sock, msg, strlen(msg));

            pthread_create(t_id + i, NULL, clnt_connection,
                           (void *)(client_info + i));
            pthread_detach(t_id[i]);
            break;
          }
        }
      }
      // If no match found in client info
      if (i == MAX_CLNT) {
        sprintf(msg, "[%s] Authentication Error!\n", pArray[0]);
        write(clnt_sock, msg, strlen(msg));
        log_file(msg);
        shutdown(clnt_sock, SHUT_WR);
      }
    } else {
      shutdown(clnt_sock, SHUT_WR);
    }
  }
  return 0;
}

// Function for handling client connection
void *clnt_connection(void *arg) {
  CLIENT_INFO *client_info = (CLIENT_INFO *)arg;
  int str_len = 0;
  int index = client_info->index;
  char msg[BUF_SIZE];
  char to_msg[MAX_CLNT * ID_SIZE + 1];
  int i = 0;
  char *pToken;
  char *pArray[ARR_CNT] = {0};
  char strBuff[130] = {0};

  MSG_INFO msg_info;
  CLIENT_INFO *first_client_info;

  first_client_info = (CLIENT_INFO *)((void *)client_info -
                                      (void *)(sizeof(CLIENT_INFO) * index));

  // Main loop to receive and forward client messages
  while (1) {
    memset(msg, 0x0, sizeof(msg));
    str_len = read(client_info->fd, msg, sizeof(msg) - 1);
    if (str_len <= 0)
      break;

    msg[str_len] = '\0';
    pToken = strtok(msg, "[:]");
    i = 0;
    while (pToken != NULL) {
      pArray[i] = pToken;
      if (i++ >= ARR_CNT)
        break;
      pToken = strtok(NULL, "[:]");
    }

    msg_info.fd = client_info->fd;
    msg_info.from = client_info->id;
    msg_info.to = pArray[0];
    sprintf(to_msg, "[%s]%s", msg_info.from, pArray[1]);
    msg_info.msg = to_msg;
    msg_info.len = strlen(to_msg);

    sprintf(strBuff, "msg : [%s->%s] %s", msg_info.from, msg_info.to,
            pArray[1]);
    log_file(strBuff);
    send_msg(&msg_info, first_client_info);
  }

  close(client_info->fd);
  sprintf(strBuff, "Disconnect ID:%s (ip:%s,fd:%d,sockcnt:%d)\n",
          client_info->id, client_info->ip, client_info->fd, clnt_cnt - 1);
  log_file(strBuff);

  pthread_mutex_lock(&mutx);
  clnt_cnt--;
  client_info->fd = -1;
  pthread_mutex_unlock(&mutx);

  return 0;
}

// Send message to specified client(s)
void send_msg(MSG_INFO *msg_info, CLIENT_INFO *first_client_info) {
  int i = 0;

  if (!strcmp(msg_info->to, "ALLMSG")) {
    // Broadcast to all connected clients
    for (i = 0; i < MAX_CLNT; i++)
      if ((first_client_info + i)->fd != -1)
        write((first_client_info + i)->fd, msg_info->msg, msg_info->len);
  } else if (!strcmp(msg_info->to, "IDLIST")) {
    // Send list of all connected client IDs
    char *idlist = (char *)malloc(ID_SIZE * MAX_CLNT);
    msg_info->msg[strlen(msg_info->msg) - 1] = '\0';
    strcpy(idlist, msg_info->msg);

    for (i = 0; i < MAX_CLNT; i++) {
      if ((first_client_info + i)->fd != -1) {
        strcat(idlist, (first_client_info + i)->id);
        strcat(idlist, " ");
      }
    }
    strcat(idlist, "\n");
    write(msg_info->fd, idlist, strlen(idlist));
    free(idlist);
  } else {
    // Send message to specific client ID
    for (i = 0; i < MAX_CLNT; i++)
      if ((first_client_info + i)->fd != -1)
        if (!strcmp(msg_info->to, (first_client_info + i)->id))
          write((first_client_info + i)->fd, msg_info->msg, msg_info->len);
  }
}

// Log message to standard output
void log_file(char *msgstr) { fputs(msgstr, stdout); }
