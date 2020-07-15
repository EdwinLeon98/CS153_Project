#include "user.h"
#include "types.h"
#include "stat.h"

int main(int argc, char *argv[]){
	int pid;
	int pid2;
	int status;
	int i;
	for(i = 0; i < 2; ++i) {
		pid = fork();
		if(pid == 0) {
			printf(1, "This process is a child. PID: %d\n", pid);
			exit(0);
		} else if(pid > 0) {
			pid2 = wait(&status);
			printf(1, "This process is a parent. PID: %d\n", pid2);
		} else {
			printf(1, "Error.\n");
			exit(-1);
		}
	}
	return 0;
}
