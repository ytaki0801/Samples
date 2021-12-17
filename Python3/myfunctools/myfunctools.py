from operator import not_

def unfold_right(p, f, g, seed, init=[]):
    e, r = seed, init
    while not p(e): e, r = g(e), [f(e)] + r
    return r

def find_tail(p, a):
    r = a
    while r:
        if p(r[0]): break
        else: r = r[1:]
    return r if r else False

def reverse(a):
    def f(x): return x[0]
    def g(x): return x[1:]
    return unfold_right(not_, f, g, a)

def append(a, b):
    def f(x): return x[0]
    def g(x): return x[1:]
    return unfold_right(not_, f, g, reverse(a), b)

def map1(func, s):
    def f(x): return func(x[0])
    def g(x): return x[1:]
    return unfold_right(not_, f, g, reverse(s))

def iota(c, *rest):
    if   len(rest) == 0: s, d = 0, 1
    elif len(rest) == 1: s, d = rest[0], 1
    else: s, d = rest[0], rest[1]
    def p(x): return x > c - 1
    def f(x): return x * d + s
    def g(x): return x + 1
    return reverse(unfold_right(p, f, g, 0))

def find(p, s):
    r = find_tail(p, s)
    return r[0] if r else r

def member(e, s):
    def p(x): return x == e
    return find_tail(p, s)

def assoc(k, al):
    def p(x): return x[0] == k
    return find_tail(p, al)[0]

def filter(pred, s):
    def f(x): return x[0]
    def g(x): return find_tail(pred, x[1:])
    return unfold_right(not_, f, g, find_tail(pred, reverse(s)))

