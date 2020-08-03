# Example 1

def func(y):
    def func(z):
        def func(w):
            def func(x): return y if x > 0 else z if x < 0 else w
            return func
        return func
    return func

func1 = func('positive')('negative')
func2 = func1('zero')
print(func2(1))     # => positive
print(func2(-1))    # => negative
print(func2(0))     # => zero
func2 = func1('ゼロ')
print(func2(0))     # => ゼロ
T = (3, -2, 0, 1, -7)
print(dict(zip(T, map(func2, T))))
# => {3: 'positive', -2: 'negative', 0: 'ゼロ', 1: 'positive', -7: 'negative'}
def recur(f, t): return f if not t else recur(f(t[0]), t[1:])
print(dict(zip(T, map(recur(func, ('正', '負', 'ゼロ')), T))))
# => {3: '正', -2: '負', 0: 'ゼロ', 1: '正', -7: '負'}


# Example 2

def is_t(t):
    def r(v): return isinstance(v, t)
    return r

T = 10, "hoge", 20.4, False, "hage"
print(tuple(map(is_t(str), T)))    # => (False, True, False, False, True)
print(tuple(map(is_t(int), T)))    # => (True, False, False, True, False)


# Example 3

def func(x):
    def func(y): return (x * y)
    return func

fx = func(5)
print([fx(y) for y in range(10)])    # => [0, 5, 10, 15, 20, 25, 30, 35, 40, 45]
fy = [func(x) for x in range(10)]
print([y(5) for y in fy])            # => [0, 5, 10, 15, 20, 25, 30, 35, 40, 45]
