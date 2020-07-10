def threetimes(f):
    return (lambda x, y: f(f(f(x, y), y), y))

def f(x, y):
    return (x + y)

threetimes(f)(10, 5)
# => f(f(f(10, 5), 5), 5)
# => (((10 + 5) + 5) + 5) = 25

def f(x, y):
    return (2 * x + y)

threetimes(f)(10, 5)
# => f(f(f(x, y), y), y)
# => (2 * (2 * (2 * 10 + 5) + 5) + 5) = 115

@threetimes
def f(x, y):
    return(x + y)

f(10, 5) # => 25

@threetimes
def f(x, y):
    return(2 * x + y)

f(10, 5) # =>  115

def args_10_5(f):
    return (lambda : f(10, 5))

args_10_5(f)() # => f(10, 5)

def f(x):
    return (lambda y: lambda z: lambda w: 4 * x + 3 * y + 2 * z + w)

f(2)(3)(4)(5) # => 4 * 2 + 3 * 3 + 2 * 4 + 5 = 30

def unfold(pred, f, update, seed):
    if pred(seed):
        return ([])
    else:
        r = unfold(pred, f, update, update(seed))
        r.insert(0, f(seed))
        return (r)

unfold(lambda x: x > 10, lambda x: x * x, lambda x: x + 1, 1)
# => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
