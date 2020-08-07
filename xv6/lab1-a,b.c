#include "types.h"
#include "user.h"

int exitWait(void);

int main(int argc, char *argv[])
{
  printf(1, "\n This program tests the correctness of the new wait and exit systemcalls\n");
  
	exitWait();
	exitS(0);
	return 0;
 }
  
int exitWait(void) {
	  int pid, ret_pid, exit_status;
       int i;
  // use this part to test exit(int status) and wait(int* status)
 
  printf(1, "\n  Parts a & b) testing exit(int status) and wait(int* status):\n");

  for (i = 0; i < 2; i++) {
    pid = fork();
    if (pid == 0) { // only the child executed this code
      if (i == 0)
      {
      printf(1, "\nThis is child with PID# %d and I will exit with status %d\n", getpid(), 0);
      exitS(0);
      }
      else
      {
	    printf(1, "\nThis is child with PID# %d and I will exit with status %d\n" ,getpid(), -1);
      exitS(-1);
      } 
    }else if (pid > 0) { // only the parent executes this code
      ret_pid = wait(&exit_status);
      printf(1, "\n This is the parent: child with PID# %d has exited with status %d\n", ret_pid, exit_status);
    } else{  // something went wrong with fork system call
      
	  printf(2, "\nError using fork\n");
    exitS(-1);
    }
  }
  return 0;
}
