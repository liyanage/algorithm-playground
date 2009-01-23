

Element *mt_from_last(Element *head, int m) {
	Element *current = head;
	int count;
	for (count = 1; count < m; count++) {
		if (current->next) {
			current = current->next;
		} else {
			return NULL;
		}
	}
	
	
	Element *mBehind = head;
	while(current->next) {
		current = current->next;
		mBehind = mBehind->next;
	}
	
	return mBehind;

}





Element *mt_from_last(Element *head, int m) {
	if (!head) return NULL;
	Element *current = head;
	
	if (!m) {
		while (current) {
			if (!current->next) return current;
			current = current->next;
		}
	}

	Element *history[] = malloc(m * sizeof(Element *));

/*
length 3, m 2

count = 1
slot 1
0 x
1 1

count = 2
slot = 0
0 2
1 1

count = 3
slot = 1
0 2
1 1

3 - 2 % m = 1

*/

/*

length 1, m 2

count = 1
slot 1
0 x
1 x

*/


	int count = 0;
	int slot = 0;
	Element *target = NULL;
	while (current) {
		count++;
		slot = count % m;
		if (current->next) {
			history[slot] = current;
			current = current->next;
			continue;
		}
		
		if (count <= m) break;

		target_slot = (count - m) % m;
		target = history[target_slot];
	}

	free(history);
	return target;

}













