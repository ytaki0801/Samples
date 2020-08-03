def fix(f):
    def ret(x):
        return fix(f)(x)
    return f(ret)

print(fix(lambda fib: lambda f1: lambda f2: lambda n: f1 if n == 0 else fib(f2)(f1+f2)(n-1))(0)(1)(40))
# => 102334155
print(list(map(fix(lambda fib: lambda f1: lambda f2: lambda n: f1 if n == 0 else fib(f2)(f1+f2)(n-1))(0)(1), range(11))))
# => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
print(list(map(fix(lambda fib: lambda f1: lambda f2: lambda n: f1 if n == 0 else fib(f2)(f1+f2)(n-1))(0)(1), range(0,51,10))))
# => [0, 55, 6765, 832040, 102334155, 12586269025]
