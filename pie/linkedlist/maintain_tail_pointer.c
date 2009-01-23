
// global head, tail


bool remove(Element *elem) {
	if (!(head && elem)) return false;
	Element *next = NULL;

	if (head == elem) {
		next = head->next;
		head = next;
		if (tail == elem) {
			tail = next;
		}
		delete elem;
		return true;
	}
	
	Element *current = head;
	while (current) {
		next = current->next;
		if (next == elem) {
			current->next = next->next;
			if (tail == next) {
				tail = current;
			}
			delete elem;
			return true;
		}
		current = next;
	}
	
	return false;
}




bool insertAfter(Element *elem, int data) {
	Element *newElem = new Element;
	if (!newElem) return false;
	newElem->data = data;

	if (!elem) {
		newElem->next = head;
		head = newElem;
		if (!tail) tail = newElem;
		return true;
	}

	Element *next = elem->next;
	elem->next = newElem;
	newElem->next = next;
	
	if (tail == elem) tail = newElem;

// 	
// 	Element *current = head, *next = NULL;
// 	while (current) {
// 		next = current->next;
// 		if (elem == current) {
// 			newElem->next = next;
// 			current->next = newElem;
// 			if (current == tail) {
// 				tail = newElem;
// 			}
// 		}
// 		current = next;
// 	}
// 	return false;
	
}