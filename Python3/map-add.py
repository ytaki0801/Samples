from time import time
from operator import add

R1 = range(9999999,-1,-1)
R2 = range(0,10000000)

start = time()
a = tuple(map(add, R1, R2))
print("          map + add: ", time() - start)

start = time()
b = tuple(map((lambda x,y: x + y), R1, R2))
print("       map + lambda: ", time() - start)

start = time()
c = tuple(x + y for x,y in zip(R1, R2))
print("comprehension + zip: ", time() - start)
