
#include <stdio.h>
#include <string.h>

char *reverse_words(const char *string);
void reverse_range(char *start, unsigned int len);

int main() {
	char *reversed = reverse_words("Do or do not, there is no try.");
	printf("reversed: %s\n", reversed);
}


char *reverse_words(const char *string) {
	char *copy = strdup(string);
	int len = strlen(copy);
	reverse_range(copy, len);

	char *a = copy;
	
	while (a < copy + len) {
		if (*a == ' ') {
			a++;
			continue;
		}
		
		char *b = strchr(a, ' ');
		if (!b) b = copy + len;
		reverse_range(a, b - a);
		a = b + 1;
	}	
	
	return copy;
}


void reverse_range(char *start, unsigned int len) {
//	printf("start %p, len %d %s\n", start, len, start);
	char *a = start;
	char *b = start + len - 1;
	
	while(a < b) {
		char tmp = *a;
		*a = *b;
		*b = tmp;
		a++;
		b--;
	}

}


