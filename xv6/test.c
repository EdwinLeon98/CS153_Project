#include "types.h"
#include "user.h"

int exitWait(void);
int waitpidTest(void);

int main(int argc, char *argv[])
{
  	printf(1, "\n This program tests the correctness of the new wait and exit systemcalls\n");
	exitWait();
	printf(1, "\n This program tests the correctness of waitpid ststemcall\n");
	waitpidTest();
	exit(0);
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
                	if (i == 0){
                        	printf(1, "\nThis is child with PID# %d and I will exit with status %d\n", getpid(), 0);
                                exit(0);
                        }
                        else{
  	                        printf(1, "\nThis is child with PID# %d and I will exit with status %d\n" ,getpid(), -1);
                                exit(-1);
      	                } 
     		}
		else if (pid > 0) { // only the parent executes this code
         	        ret_pid = wait(&exit_status);
                        printf(1, "\n This is the parent: child with PID# %d has exited with status %d\n", ret_pid, exit_status);
                }
		else {  // something went wrong with fork system call            	                                          
                        printf(2, "\nError using fork\n");
                        exit(-1);
                }
	}
        return 0;
}

int waitpidTest(void){
	int exit_status;
	int ret_pid;
	int pid[5];
	int i;
	for(i = 0; i < 5; i++){
		if((pid[i] = fork()) == 0){
			printf(1, "\n This is the child with PID# %d and I will exit with status %d\n", getpid(), i);
			printf(1, "\n");
			exit(i);
		}
	}
	for(i = 0; i < 5; i++){
		sleep(5);
         	ret_pid = waitpid(pid[i], &exit_status, 0);
     		printf(1, "\n This is the parent: child with PID# %d has exit status %d\n", ret_pid, exit_status);
        }	
	return 0;
}
