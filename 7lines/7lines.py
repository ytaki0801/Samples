# readlist('(hoge hage (hige (foo bar)) baz)')
# => ('hoge', 'hage', ('hige', ('foo', 'bar')), 'baz')
def readlist(x):
    xl = x.replace('(', ' ( ').replace(')', ' ) ').split()
    def ret(ts):
        t = ts.pop(0)
        if t == '(':
            r = []
            while ts[0] != ')': r.append(ret(ts))
            ts.pop(0)
            return tuple(r)
        else:
            return t
    return ret(xl)

# assoc('a', (('a', 10), ('b', 20), ('c', 30)))
# => ('a', 10)
def assoc(k, vl):
    if not vl: return False
    elif vl[0][0] == k: return vl[0]
    else: return assoc(k, vl[1:])

# 7 lines interpreter derived from:
# http://matt.might.net/articles/implementing-a-programming-language/
def eval7(e, env):
    if isinstance(e, str): return assoc(e, env)[1]
    elif e[0] == '/':     return (e,) + env
    else:                  return apply7(eval7(e[0], env), eval7(e[1], env))

def apply7(f, x): return eval7(f[0][3:][0], ((f[0][1], x),) + f[1:])

# writelist(('hoge', 'hage', ('hige', ('foo', 'bar')), 'baz'))
# => (hoge hage (hige (foo bar)) baz)'
def writelist(x):
    def ret(xs):
        r = ('(')
        for t in xs:
            if isinstance(t, tuple):
                r += ret(t)
            else:
                r = r + t + ' '
        r = r[:-1] + ') '
        return r
    return ret(x)[:-1]

# In:  (((/ f . (/ x . (f x))) (/ a . a )) (/ b . b))
# Out: ((/ b . b))
#print(writelist(eval7(readlist(raw_input()), ())))
print(writelist(eval7(readlist(input()), ())))
