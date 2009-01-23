
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <string.h>

int main(int argc, char *argv[]) {
	char *string = argv[1];
	assert(string);
	
	char *c = NULL;
	int exp = 0;
	int value = 0;
	c = string + strlen(string) - 1;
	while (c >= string) {
		if (*c == '-') {
			value = -value;
			break;
		}
		int digitvalue = *c - '0';
		if (!(digitvalue >= 0 && digitvalue <= 9)) {
			c--;
			continue;
		}
		value += digitvalue * pow(10, exp++);
		c--;
	}

	
	printf("string: %s, value: %d\n", string, value);
	
}

