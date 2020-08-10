L = range(1,4)
print([[x, y] for x in L for y in L if x != y])
# => [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]

print((lambda L: [[x, y] for x in L for y in L if x != y])(range(1, 4)))
# => [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]

