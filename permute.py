

counter = 0
def permute(items):
    global counter
    counter += 1
    if len(items) == 1:
        yield items
        return
    for index, item in enumerate(items):
        items[index] = items[0]
        for result in permute(items[1:]):
            yield [item] + result
        items[index] = item


counter2 = 0
cache = {}
def permute2(items):
    global counter2
    global cache
    counter2 += 1
    if len(items) == 1:
        return [items]
    output = []
    for index, item in enumerate(items):
        items[index] = items[0]
        key = ''.join(items[1:])
        if key in cache:
            results = cache[key]
            print 'cache miss'
        else:
            print 'cache hit'
            cache[key] = results = permute2(items[1:])
        for result in results:
            output.append([item] + result)
        items[index] = item
    return output


items = 'a b c d e f'.split()
# for i in permute(items):
#     pass
#     print i
# print counter

for i in permute2(items):
    print i
print counter2
