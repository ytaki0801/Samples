from functools import reduce
from time import time
from operator import mul

R1 = range(1,100000)

start = time()
a = reduce(mul, R1)
print("   reduce + mul: ", time() - start)

start = time()
a = reduce(lambda x, y: x * y, R1)
print("reduce + lambda: ", time() - start)
