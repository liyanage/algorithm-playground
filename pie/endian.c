
#include <stdio.h>

int main(int argc, char *argv[]) {
	int value = 1;
	char *c = (char *)&value;
//	c += sizeof(int) - 1;
	printf("%d\n", *c);
	printf("%d\n", *((char *)&value));
	
}
