def fix(f):
    def ret(x):
        return fix(f)(x)
    return f(ret)

print(fix(lambda fib: lambda n: lambda f1: lambda f2: f1 if n == 0 else fib(n-1)(f2)(f1+f2))(50)(0)(1))
print(list(map(lambda x: fix(lambda fib: lambda n: lambda f1: lambda f2: f1 if n == 0 else fib(n-1)(f2)(f1+f2))(x)(0)(1), range(11))))
print(list(map(lambda x: fix(lambda fib: lambda n: lambda f1: lambda f2: f1 if n == 0 else fib(n-1)(f2)(f1+f2))(x)(0)(1), range(0,51,10))))
