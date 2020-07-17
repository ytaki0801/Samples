#### not tail-recur
#def fib(x):
#    if x == 0:
#      return (0)
#    elif x == 1:
#      return (1)
#    else:
#      return (fib(x-1) + fib(x-2))

def fib(x):
  def fib_r(x,a,b):
      if x == 0:
        return (a)
      else:
        return (fib_r(x-1, b, a+b))
  return (fib_r(x,0,1))

for i in range(45):
  print(fib(i), "", end="")

