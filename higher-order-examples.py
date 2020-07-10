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

