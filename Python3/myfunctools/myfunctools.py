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
    def p(x): return not x
    def f(x): return x[0]
    def g(x): return x[1:]
    return unfold_right(p, f, g, a)

def append(a, b):
    def p(x): return not x
    def f(x): return x[0]
    def g(x): return x[1:]
    return unfold_right(p, f, g, reverse(a), b)

def map1(f1, s):
    def p(x): return not x
    def f(x): return f1(x[0])
    def g(x): return x[1:]
    return unfold_right(p, f, g, reverse(s))

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
    return find_tail(lambda x: x[0] == k, al)[0]

def filter(p, s):
    return unfold_right(lambda x: not x,
                        lambda x: x[0],
                        lambda x: find_tail(p, x[1:]),
                        find_tail(p, reverse(s)))

