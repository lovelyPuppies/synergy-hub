#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define BUF_SIZE 30
void error_handling(char *message);
void read_routine(int sock, char *buf);
void write_routine(int sock, char *buf);
// 비동기적 수행
int main(int argc, char *argv[]) {
  int sock;
  pid_t pid;
  char buf[BUF_SIZE];
  struct sockaddr_in serv_adr;
  if (argc != 3) {
    printf("Usage : %s <IP> <port>\n", argv[0]);
    exit(1);
  }

  sock = socket(PF_INET, SOCK_STREAM, 0);
  memset(&serv_adr, 0, sizeof(serv_adr));
  serv_adr.sin_family = AF_INET;
  serv_adr.sin_addr.s_addr = inet_addr(argv[1]);
  serv_adr.sin_port = htons(atoi(argv[2]));

  if (connect(sock, (struct sockaddr *)&serv_adr, sizeof(serv_adr)) == -1)
    error_handling("connect() error!");

  pid = fork();
  if (pid == 0)
    write_routine(sock, buf);
  else
    read_routine(sock, buf);

  close(sock);
  return 0;
}

void read_routine(int sock, char *buf) {
  while (1) {
    int str_len = read(sock, buf, BUF_SIZE);
    if (str_len == 0)
      return;

    buf[str_len] = 0;
    printf("Message from server: %s", buf);
  }
}
void write_routine(int sock, char *buf) {
  while (1) {
    // ❓ fork()가 호출되면 자식 프로세스가 생성됩니다. 이 시점에서 부모와 자식 프로세스는 같은 표준 입력(stdin), 출력(stdout), 에러(stderr)를 공유하게 됩니다.
    fgets(buf, BUF_SIZE, stdin);
    if (!strcmp(buf, "q\n") || !strcmp(buf, "Q\n")) {
      // shutdown(sock, SHUT_WR): 소켓의 쓰기 방향을 닫습니다(SHUT_WR). 이로써 서버는 더 이상 클라이언트로부터 데이터를 받을 수 없으며, 서버는 클라이언트의 종료를 알 수 있습니
      shutdown(sock, SHUT_WR);
      return;
    }
    write(sock, buf, strlen(buf));
  }
}
void error_handling(char *message) {
  fputs(message, stderr);
  fputc('\n', stderr);
  exit(1);
}