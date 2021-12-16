from myfunctools import unfold_right, find_tail
from myfunctools import reverse, append, map1, range
from myfunctools import find, member, assoc, filter

print(reverse([1, 2, 3, 4, 5]))
# => [5, 4, 3, 2, 1]

print(append(['a', 'b', 'c'], ['x', 'y', 'z']))
# => ['a', 'b', 'c', 'x', 'y', 'z']

print(map1(lambda x: x + 1, [10, 20, 30, 40, 50]))
# => [11, 21, 31, 41, 51]

print(range(10))
# => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
print(range(11, 17))
# => [11, 12, 13, 14, 15, 16]
print(range(0, 10, 2))
# => [0, 2, 4, 6, 8]

print(find(lambda x: x == 'c', ['a', 'b', 'c', 'd', 'e']))
# => c
print(find(lambda x: x == 'z', ['a', 'b', 'c', 'd', 'e']))
# => False

print(member('c', ['a', 'b', 'c', 'd', 'e']))
# => ['c', 'd', 'e']
print(member('z', ['a', 'b', 'c', 'd', 'e']))
# => False

print(assoc('b', [('a',1), ('b',2), ('c',3), ('b',4), ('e',5)]))
# => ('b', 2)

print(filter(lambda x: x % 2 == 0, range(0, 10)))
# => [0, 2, 4, 6, 8]
print(filter(lambda x: x % 2 == 0, range(1, 12, 2)))
# => []

