

class Node(object):
    
    def __init__(self, value):
        self.adjacent = []
        self.value = value
    
    def __repr__(self):
        return '<Node {}>'.format(self.value)
    


def shortest_path(source, target):
    seen = set()
    queue = [[source]]
    
    while queue:
        path = queue.pop(0)
        if path[-1] == target:
            return path
        if path[-1] in seen:
            continue
        seen.add(path[-1])
        queue.extend([path + [adjacent] for adjacent in path[-1].adjacent])
    
    return []


a = Node('a')
b = Node('b')
c = Node('c')
d = Node('d')

a.adjacent.append(b)
b.adjacent.append(c)
c.adjacent.append(a)
c.adjacent.append(d)
b.adjacent.append(d)
#a.adjacent.append(d)


print shortest_path(a, d)