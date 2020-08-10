fix = lambda f: f(lambda x: fix(f)(x))
print(
    fix(
        lambda fib: lambda f1: lambda f2: lambda n:
            f1 if n == 0 else fib(f2)(f1+f2)(n-1)
       )(0)(1)(40)
)
# => 102334155

print(
    (lambda f:
        (lambda x: f(lambda y: x(x)(y)))
        (lambda x: f(lambda y: x(x)(y)))
    )
    (lambda fib: lambda f1: lambda f2: lambda n:
        f1 if n == 0 else fib(f2)(f1+f2)(n-1)
    )(0)(1)(40)
)
# => 102334155
