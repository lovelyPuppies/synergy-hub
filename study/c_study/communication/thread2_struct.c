#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct param {
  int thread_param;
  char *msg;
};

void *thread_main(void *arg);
int main(int argc, char *argv[]) {
  pthread_t t_id;
  void *thr_ret;

  struct param s_param;
  s_param.thread_param = 5;
  s_param.msg = (char *)malloc(sizeof(char) * 50);
  strcpy(s_param.msg, "hi");

  if (pthread_create(&t_id, NULL, thread_main, (void *)&s_param) < 0) {
    puts("pthread_create() error");
    return 1;
  };

  if (pthread_join(t_id, &thr_ret) < 0) {
    puts("pthread_join() error");
    return -1;
  };

  printf("Thread return message: %s \n", ((struct param *)thr_ret)->msg);
  printf("s_param.msg: %s \n", s_param.msg);
  free(s_param.msg);
  return 0;
}

void *thread_main(void *arg) {
  int i;
  struct param *s_par = (struct param *)arg;
  printf("s_par->msg : %s\n", s_par->msg);

  strcpy(s_par->msg, "Hello, I'am thread~ \n");
  for (i = 0; i < s_par->thread_param; i++) {
    sleep(1);
    puts("running thread");
  }
  return (void *)s_par;
}
