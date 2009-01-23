
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
	struct Node *left, *right;
	int value;
} Node;

void print_node(Node *node, void *context);
void traverse_preorder(Node *root, void (*func)(Node *node, void *context), void *context);
Node *make_node(int value, Node *left, Node *right);
Node *find_common_ancestor(Node *node, int a, int b);

int main2() {
	Node *n110 = make_node(110, NULL, NULL);
	Node *n125 = make_node(125, n110, NULL);
	Node *n175 = make_node(175, NULL, NULL);
	Node *n150 = make_node(150, n125, n175);
	Node *n25  = make_node(25,  NULL, NULL);
	Node *n75  = make_node(75,  NULL, NULL);
	Node *n50  = make_node(50,  n25,  n75);
	Node *n100 = make_node(100, n50,  n150);
	Node *root = n100;
	
	int sum = 0;
	traverse_preorder(root, print_node, &sum);
}

int main() {
	Node *n10  = make_node(10, NULL, NULL);
	Node *n14  = make_node(14, NULL, NULL);
	Node *n12  = make_node(12, n10,  n14);
	Node *n4   = make_node( 4, NULL, NULL);
	Node *n8   = make_node( 8, n4,   n12);
	Node *n22  = make_node(22, NULL, NULL);
	Node *n20  = make_node(20, n8,   n22);

	Node *root = n20;
	
	Node *ancestor = find_common_ancestor(root, 10, 14);
	printf("ancestor: %d\n", ancestor->value);
}



Node *make_node(int value, Node *left, Node *right) {
	Node *node = malloc(sizeof(Node));
	node->left = left;
	node->right = right;
	node->value = value;
	return node;
}



Node *find_common_ancestor(Node *node, int a, int b) {
	if (a < node->value && b < node->value) return find_common_ancestor(node->left, a, b);
	if (a > node->value && b > node->value) return find_common_ancestor(node->right, a, b);
	return node;
}



void traverse_preorder(Node *node, void (*func)(Node *node, void *context), void *context) {
	if (!node) return;
	func(node, context);
	traverse_preorder(node->left, func, context);
	traverse_preorder(node->right, func, context);
}


void print_node(Node *node, void *context) {
	int *sum = (int *)context;
	*sum += node->value;
	printf("%d, context: %p, sum: %d\n", node->value, context, *sum);
}

