#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <unistd.h>

#define MAX_EVENTS 10
#define BUF_SIZE   1024

int main() {
  int server_fd, client_fd, epoll_fd, event_count, read_size;
  struct sockaddr_in server_addr, client_addr;
  socklen_t addr_len = sizeof(client_addr);
  char buffer[BUF_SIZE];
  struct epoll_event event, events[MAX_EVENTS];

  // 서버 소켓 생성
  server_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (server_fd == -1) {
    perror("socket() error");
    exit(1);
  }

  // 서버 주소 설정
  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = INADDR_ANY;
  server_addr.sin_port = htons(8080);

  // 바인드 및 리슨
  bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr));
  listen(server_fd, 10);

  // epoll 인스턴스 생성
  epoll_fd = epoll_create1(0);
  if (epoll_fd == -1) {
    perror("epoll_create1() error");
    exit(1);
  }

  // 서버 소켓을 epoll에 등록
  event.events = EPOLLIN; // 읽기 이벤트
  event.data.fd = server_fd;
  epoll_ctl(epoll_fd, EPOLL_CTL_ADD, server_fd, &event);

  printf("Server is running on port 8080...\n");

  // 이벤트 루프
  while (1) {
    event_count = epoll_wait(epoll_fd, events, MAX_EVENTS, -1); // 이벤트 대기
    for (int i = 0; i < event_count; i++) {
      if (events[i].data.fd == server_fd) {
        // 새 클라이언트 연결 수락
        client_fd =
            accept(server_fd, (struct sockaddr *)&client_addr, &addr_len);
        printf("New client connected: %d\n", client_fd);

        // 클라이언트 소켓을 epoll에 등록
        event.events = EPOLLIN;
        event.data.fd = client_fd;
        epoll_ctl(epoll_fd, EPOLL_CTL_ADD, client_fd, &event);
      } else {
        // 클라이언트 데이터 처리
        read_size = read(events[i].data.fd, buffer, BUF_SIZE);
        if (read_size <= 0) {
          printf("Client disconnected: %d\n", events[i].data.fd);
          close(events[i].data.fd);
        } else {
          printf("Received data: %s\n", buffer);
          write(events[i].data.fd, buffer, read_size); // Echo back
        }
      }
    }
  }

  close(server_fd);
  close(epoll_fd);
  return 0;
}
