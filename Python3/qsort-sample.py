D = range(20)
print(list(D))

def qsort1(L):
    if not L: return []
    else:
        p = L[0]
        LL = qsort1([x for x in L[1:] if x >  p])
        LR = qsort1([x for x in L[1:] if x <= p])
        return LL + [p] + LR
print(list(qsort1(D)))

def qsort2(L):
    if not L: return []
    else:
        p = L[0]
        LL = qsort2(list(filter(lambda x: x >  p, L[1:])))
        LR = qsort2(list(filter(lambda x: x <= p, L[1:])))
        return LL + [p] + LR
print(list(qsort2(D)))
