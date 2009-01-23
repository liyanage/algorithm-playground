
#include <stdio.h>
#include <assert.h>

void count_ones1(int value);
void count_ones2(int value);

int main(int argc, char *argv[]) {
	assert(argv[1] != NULL);
	int value = atoi(argv[1]);
	count_ones1(value);
	count_ones2(value);
}


void count_ones1(int value) {
	int i;
	int count = 0;
	for (i = 0 ; i < sizeof(int) * 4; i++) {
		if (value & (1 << i)) count++;
	}
	printf("ones: %d\n", count);
}


void count_ones2(int value) {
	int count = 0;
	while (value) {
		if (value & 1) count++;
		value = value >> 1;
	}
	printf("ones: %d\n", count);
}

