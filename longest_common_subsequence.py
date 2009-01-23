#!/usr/bin/env python

def lcs(a, b, cache):
    if not (a and b):
        return []

    key = a, b
    if key in cache:
        return cache[key]
    
    if a[-1] == b[-1]:
        value = lcs(a[:-1], b[:-1], cache) + [a[-1]]
    else:
        lcs1, lcs2 = lcs(a, b[:-1], cache), lcs(a[:-1], b, cache)
        value = lcs1 if len(lcs1) > len(lcs2) else lcs2

    cache[key] = value
    return value

a = tuple('BANANAANAABAAENEA')
b = tuple('ATANAANANABABN')

print ''.join(lcs(a, b, {}))

# import timeit
# print timeit.timeit(lambda: lcs(a, b, {}), number=10000)
