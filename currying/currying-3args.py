def func(x,y,z): return (x - y) * (x - z)
print(func(10,2,3))      # => 56

def func(x):
    def func(y):
        def func(z): return ((x - y) * (x - z))
        return func
    return func
print(func(10)(2)(3))    # => 56

# x = 10, y = 2, z = 0 1 2 3 4
fxy = func(10)(2)
fxyz = (fxy(z) for z in range(5))
print(tuple(fxyz))    # => (80, 72, 64, 56, 48)

# x = 10, y = 0 1 2 3 4, z = 3
fx = func(10)
fxy = (fx(y) for y in range(5))
fxyz = (z(3) for z in fxy)
print(tuple(fxyz))    # => (70, 63, 56, 49, 42)

# x = 0 1 2 3 4, y = 2, z = 3
fx = (func(x) for x in range(5))
fxyz = (z(2)(3) for z in fx)
print(tuple(fxyz))    # => (6, 2, 0, 0, 2)
