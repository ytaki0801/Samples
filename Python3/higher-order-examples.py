# 
# basics of higher-order function and decorators
#

def threetimes(f):
    def retfunc(x, y):
        print(f(f(f(x, y), y), y))
    return (retfunc)

def f(x, y):
    return (2 * x + y)

threetimes(f)(10, 5)
# => f(f(f(x, y), y), y)
# => (2 * (2 * (2 * 10 + 5) + 5) + 5) => "115"

def threetimes_message(mes = ""):
    def _threetimes(f):
        def retfunc(x, y):
            print(mes, end="")
            print(f(f(f(x, y), y), y))
        return (retfunc)
    return (_threetimes)

threetimes_message("Result = ")(f)(10, 5)
# => "Result = 115"

threetimes_message()(f)(10, 5)
# => "115"

@threetimes
def f(x, y):
    return(2 * x + y)

f(10, 5) # => "115"

@threetimes_message(mes = "Result = ")
def f(x, y):
    return(2 * x + y)

f(10, 5) # => "Result = 115"

@threetimes_message()
def f(x, y):
    return (2 * x + y)

f(10, 5) # => "115"


#
# other stuff from https://ja.wikipedia.org/wiki/%E9%AB%98%E9%9A%8E%E9%96%A2%E6%95%B0
#

def args_10_5(f):
    def _args_10_5():
        f(10, 5)
    return (_args_10_5)

def f(x, y):
  print("x = ", x, ", y = ", y)

args_10_5(f)() # => "x =  10 , y =  5"

def f(x, y, z, w):
  return (4 * x + 3 * y + 2 * z + w)

f(2, 3, 4, 5) # => 30

def f(x):
    return (lambda y: lambda z: lambda w: 4 * x + 3 * y + 2 * z + w)

f(2)(3)(4)(5) # => 30

def unfold(pred, f, update, seed):
    if pred(seed):
        return ([])
    else:
        r = unfold(pred, f, update, update(seed))
        r.insert(0, f(seed))
        return (r)

unfold(lambda x: x > 10, lambda x: x * x, lambda x: x + 1, 1)
# => [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
