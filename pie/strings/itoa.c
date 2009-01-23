
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

int main(int argc, char *argv[]) {
	int value = -1234;
	bool isNegative = false;
	if (value < 0) {
		isNegative = true;
		value *= -1;
	}

	int bufsize = 15;
	char output[bufsize];
	memset(output, 0, bufsize);

	int index = bufsize - 2;	
	
	do {
		int digit = value % 10;
		value = value / 10;
		printf("value: %d, digit: %d\n", value, digit);
		output[index] = digit + '0';
		index--;
	} while (value);

	if (isNegative) {
		output[index] = '-';
	} else {
		index++;
	}
	
	printf("string: %s\n", output + index);
	
	

}