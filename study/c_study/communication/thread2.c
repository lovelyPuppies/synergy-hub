#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct _param {
  int thread_param; // Stores the number of repetitions
  char *msg;        // Pointer to the message
} param;

void *thread_main(void *arg); // Declaration of the thread function

int main(int argc, char *argv[]) {
  pthread_t t_id; // Thread identifier
  void *thr_ret;  // Thread return value
  param s_param;  // Instance of the structure for passing parameters

  // ▶️ Initialize structure instance
  s_param.thread_param = 5;               // Set number of repetitions
  s_param.msg = "Hello, I am thread~ \n"; // Set message

  // ▶️ Create thread
  // `pthread_create` is called to create a new thread and pass the `s_param` structure as an argument.
  if (pthread_create(&t_id, NULL, thread_main, (void *)&s_param) != 0) {
    puts("pthread_create() error"); // Display error message
    return -1;                      // Exit the program if there is an error
  }

  // ▶️ Wait for thread to finish
  // `pthread_join` is called to wait for the thread to finish and store the thread's return value in `thr_ret`.
  if (pthread_join(t_id, &thr_ret) != 0) {
    puts("pthread_join() error"); // Display error message
    return -1;                    // Exit the program if there is an error
  }

  // ▶️ Display the returned message and free allocated memory
  printf("Thread return message: %s \n", (char *)thr_ret);
  free(thr_ret); // Free memory allocated by the thread
  return 0;
}

// ▶️ Define the thread function
void *thread_main(void *arg) {
  int i;
  param *p = (param *)arg; // Convert the argument to a pointer to the structure
  int cnt = p->thread_param; // Retrieve the repetition count
  char *msg = (char *)malloc(sizeof(char) *
                             50); // Allocate memory for the return message
  strcpy(msg, p->msg);            // Copy the message stored in the structure

  // ▶️ Loop to display the message
  for (i = 0; i < cnt; i++) {
    sleep(1); // Wait for 1 second
    puts("running thread");
  }
  return (void *)msg; // Return the message when the thread finishes
}
