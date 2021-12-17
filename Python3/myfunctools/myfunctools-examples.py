from myfunctools import reverse, append, map1, iota
from myfunctools import find, member, assoc, filter

print(reverse([1, 2, 3, 4, 5]))
# => [5, 4, 3, 2, 1]

print(append(['a', 'b', 'c'], ['x', 'y', 'z']))
# => ['a', 'b', 'c', 'x', 'y', 'z']

def inc(x): return x + 1
print(map1(inc, [10, 20, 30, 40, 50]))
# => [11, 21, 31, 41, 51]

print(iota(6))
# => [0, 1, 2, 3, 4, 5]
print(iota(6, 11))
# => [11, 12, 13, 14, 15, 16]
print(iota(6, 1, 2))
# => [1, 3, 5, 7, 9, 11]

def equal_c(x): return x == 'c'
print(find(equal_c, ['a', 'b', 'c', 'd', 'e']))
# => c
def equal_z(x): return x == 'z'
print(find(equal_z, ['a', 'b', 'c', 'd', 'e']))
# => False

print(member('c', ['a', 'b', 'c', 'd', 'e']))
# => ['c', 'd', 'e']
print(member('z', ['a', 'b', 'c', 'd', 'e']))
# => False

print(assoc('b', [('a',1), ('b',2), ('c',3), ('b',4), ('e',5)]))
# => ('b', 2)

def even(x): return x % 2 == 0
print(filter(even, iota(10)))
# => [0, 2, 4, 6, 8]
print(filter(even, iota(6, 1, 2)))
# => []

