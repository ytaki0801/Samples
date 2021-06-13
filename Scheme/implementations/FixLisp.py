#
# FixLisp: simple LISP evaluator
# with S-expression input/output, basic list processing,
# pseudo-integers and fixed-point combinator
#


# basic list processing: cons, car, cdr, eq, atom

def cons(x, y): return (x, y)
def car(s): return s[0]
def cdr(s): return s[1]
def eq(s1, s2): return s1 == s2
def atom(s): return isinstance(s, str) or eq(s, None) or isinstance(s, bool)


# S-expression input: s_read

def s_lex(s):
    for p in "()'": s = s.replace(p, " " + p + " ")
    return s.split()

def s_syn(s):
    def quote(x):
        if len(s) != 0 and s[-1] == "'":
            del s[-1]
            return cons("quote", cons(x, None))
        else: return x
    t = s[-1]
    del s[-1]
    if t == ")":
        r = None
        while s[-1] != "(":
            if s[-1] == ".":
                del s[-1]
                r = cons(s_syn(s), car(r))
            else: r = cons(s_syn(s), r)
        del s[-1]
        return quote(r)
    else: return quote(t)

def s_read(s): return s_syn(s_lex(s))


# S-expression output: s_string

def s_strcons(s):
    sa_r = s_string(car(s))
    sd = cdr(s)
    if eq(sd, None):
        return sa_r
    elif atom(sd):
        return sa_r + " . " + sd
    else:
        return sa_r + " " + s_strcons(sd)

def s_string(s):
    if   eq(s, None):  return "()"
    elif eq(s, True):  return "#t"
    elif eq(s, False): return "#f"
    elif atom(s):
        return s
    else:
        return "(" + s_strcons(s) + ")"


# simple meta-circular evaluator: s_eval

s_builtins = {
    "cons":   lambda x, y:   cons(x, y),
    "car":    lambda s:      car(s),
    "cdr":    lambda s:      cdr(s),
    "eq?":    lambda s1, s2: eq(s1, s2),
    "pair?":  lambda s:      not atom(s),
    "+":      lambda s1, s2: str(int(int(s1) + int(s2))),
    "-":      lambda s1, s2: str(int(int(s1) - int(s2))),
    "*":      lambda s1, s2: str(int(int(s1) * int(s2))),
    "/":      lambda s1, s2: str(int(int(s1) / int(s2)))
}

def lookup_variable_value(var, env):
    def loop(env):
        def scan(vars, vals):
            if eq(vars, None): return loop(cdr(env))
            elif eq(var, car(vars)): return car(vals)
            else: return scan(cdr(vars), cdr(vals))
        frame = car(env)
        fvar = car(frame)
        fval = cdr(frame)
        return scan(fvar, fval)
    return loop(env)

def s_eval(e, env):
    def sargs(a, env):
        if eq(a, None): return None
        else: return cons(s_eval(car(a), env), sargs(cdr(a), env))
    if atom(e):
        if e in s_builtins: return e
        else: return lookup_variable_value(e, env)
    elif eq(car(e), "quote"):
        return car(cdr(e))
    elif eq(car(e), "if"):
        pred = car(cdr(e))
        texp = car(cdr(cdr(e)))
        fexp = cdr(cdr(cdr(e)))
        if eq(s_eval(pred, env), True): return s_eval(texp, env)
        else: return False if eq(fexp, None) else s_eval(car(fexp), env)
    elif eq(car(e), "lambda"):
        lvars = car(cdr(e))
        lbody = car(cdr(cdr(e)))
        return cons("lambda", cons(lvars, cons(lbody, cons(env, None))))
    else:
        f = s_eval(car(e), env)
        args = sargs(cdr(e), env)
        return s_apply(f, args)

def s_apply(f, args):
    def pargs(al):
        if eq(al, None): return []
        else: return [car(al)] + pargs(cdr(al))
    if atom(f): return s_builtins[f](*pargs(args))
    else:
        lvars = car(cdr(f))
        lbody = car(cdr(cdr(f)))
        lenvs = car(cdr(cdr(cdr(f))))
        env = cons(cons(lvars, args), lenvs)
        return s_eval(lbody, env)

fixproc = s_eval(s_read( \
    "(lambda (f) ((lambda (x) (f (lambda (y) ((x x) y)))) (lambda (x) (f (lambda (y) ((x x) y))))))" \
), None)

s_init_env = cons(cons( \
    cons("fix",   cons("#t", cons("#f",  None))), \
    cons(fixproc, cons(True, cons(False, None)))  \
), None)


# REP: Read-Eval-Print (no Loop)

def s_rep(s): return s_string(s_eval(s_read(s), s_init_env))

# >>> s_rep("(cdr (((lambda (x) (lambda (y) (cons x y))) 'a) 'b))")
# 'b'

# >>> s_rep(" \
# ...   ((fix (lambda (fact) (lambda (n)      \
# ...           (if (eq? n '0) '1             \
# ...               (* n (fact (- n '1))))))) \
# ...    '10)")
# '3628800'

