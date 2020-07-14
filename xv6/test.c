#include "user.h"
#include "syscall.h"
#include "param.h"
#include "types.h"
#include "stat.h"
#include "fs.h"
#include "fcntl.h"
#include "traps.h"
#include "memlayout.h"

int main(int argc, char *argv[]){
	int pid;
	int pid2;
	int status;
	for(int i = 0; i < 2; ++i) {
		pid = fork();
		if(pid == 0) {
			printf(stdout, "This process is a child.\n");
			exit(0);
		} else if(pid > 0) {
			pid2 = wait(&status);
			printf(stdout, "This process is a parent.\n");
		} else {
			printf(stdout, "Error.\n");
		}
	}
	return 0;
}
