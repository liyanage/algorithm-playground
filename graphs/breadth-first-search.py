

class Node(object):
    
    def __init__(self, value):
        self.adjacent = []
        self.value = value
    
    def connect_to(self, other_node):
        if other_node in self.adjacent:
            return
        self.adjacent.append(other_node)
        other_node.connect_to(self)
    
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

a.connect_to(b)
b.connect_to(c)
#c.connect_to(a)
c.connect_to(d)
#b.connect_to(d)
#a.connect_to(d)


print shortest_path(a, d)