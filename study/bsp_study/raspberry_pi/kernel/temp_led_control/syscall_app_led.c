#include <stdio.h>
#include <unistd.h>
#include <asm-generic/unistd.h>
#pragma GCC diagnostic ignored "-Wunused-result"
#define LEFT 0
#define RIGHT 1
int main()
{
    long val=0x01;
	int i,ret;
	int flag = LEFT;

	do
	{
    	ret = syscall(__NR_mysyscall,val);
    	if(ret<0)
    	{
    		perror("syscall");
       	 	return 1;
    	}
//		puts("0:1:2:3:4:5:6:7");
		for(i=0;i<8;i++)
		{
			if(val & (0x01 << i))
				putchar('O');
			else
				putchar('X');
			if(i != 7 )
				putchar(':');
			else
				putchar('\n');
		}
		if(flag == LEFT)
		{
			if(val == 0x100)
			{
				val = 0x80;
				flag = RIGHT;
			}
			else
				val <<= 1; 
		}
		else		//right shift
		{
			if(val == 0x00)
			{
				val = 0x01;
				flag = LEFT;
			}
			else
				val >>= 1;
		}
//		putchar('\n');
		usleep(50000);
//		sleep(1);
	}while(1);
    return 0;
}

