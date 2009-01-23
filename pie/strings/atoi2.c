
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

int main(int argc, char *argv[]) {
	char *string = argv[1];
	assert(string);
	
	int value = 0;
	int len = strlen(string);
	bool isNegative = false;
	char *c = string;
	while (c < string + len) {
		if (*c == '-') {
			isNegative = true;
			c++;
			continue;
		}

		int digitvalue = *c - '0';
		if (!(digitvalue >= 0 && digitvalue <= 9)) {
			c++;
			continue;
		}
		value *= 10;
		value += digitvalue;
		c++;
	}
	
	if (isNegative) value *= -1;
	
	printf("string: %s, value: %d\n", string, value);
	
}

