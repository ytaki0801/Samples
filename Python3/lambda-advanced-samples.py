####
ToCHR = lambda n: (lambda f: lambda x: x) if n == 0 else (lambda f: lambda x: f(ToCHR(n - 1)(f)(x)))
ToINT = lambda ch: ch(lambda x: x + 1)(0)
GT = lambda a: lambda b: (lambda x: lambda y: x) if ToINT(a) > ToINT(b) else (lambda x: lambda y: y)
GT(ToCHR(10))(ToCHR(9))('T')('F')    # => 'T'
GT(ToCHR(9))(ToCHR(10))('T')('F')    # => 'F'


####
L = range(1,4)
R = []
for x in L:
    for y in L:
        if x != y:
            R += [[x, y]]
print(R)
# => [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]

L = range(1,4)
print([[x, y] for x in L for y in L if x != y])
# => [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]

print((lambda L: [[x, y] for x in L for y in L if x != y])(range(1, 4)))
# => [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]


####
fix = lambda f: f(lambda x: fix(f)(x))
print(list(map(fix(lambda fact: lambda r: lambda n:
                      r if n == 0 else fact(n * r)(n - 1)
                  )(1), range(1, 6))))
# => [1, 2, 6, 24, 120]


####
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
