from time import time
from carr import carr

N = 1000
arr_a = [i for i in range(N)]
arr_b = [i for i in range(N)]

start = time()
r = 0
for elem_a in arr_a:
    for elem_b in arr_b:
        r = r + elem_a + elem_b
print("Python for", r, ":", time() - start)

start = time()
r = carr(arr_a, arr_b, N, N)
print("     C for", r, ":", time() - start)
