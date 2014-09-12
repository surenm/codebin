#include <unistd.h>
#include <sys/types.h>
#include <errno.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#define SLEEP_TIME 3

int main(int argc, char **argv) {
  pid_t child_id;
  int status;

  child_id = fork();
  if(child_id) {
    wait(&status);
    if(status) {
      printf("Non zero exit status - %d\n", status);
    }
    exit(status);
  }
  else {
    sleep(SLEEP_TIME);
    execvp(argv[1], &argv[1]);
    exit(-1);
  }
}