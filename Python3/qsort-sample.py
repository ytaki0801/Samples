from time import time

D = range(996, -1, -1)

start = time()
def qsort1(L):
    if not L: return []
    else:
        LL = qsort1([x for x in L[1:] if x <  L[0]])
        LR = qsort1([x for x in L[1:] if x >= L[0]])
        return LL + [L[0]] + LR
a = list(qsort1(D))
print("  comprehension: ", time() - start)

start = time()
def qsort2(L):
    if not L: return []
    else:
        LL = qsort2(list(filter(lambda x: x <  L[0], L[1:])))
        LR = qsort2(list(filter(lambda x: x >= L[0], L[1:])))
        return LL + [L[0]] + LR
a = list(qsort2(D))
print("filter + lambda: ", time() - start)

#   comprehension:  0.1841585636138916
# filter + lambda:  0.3261446952819824
