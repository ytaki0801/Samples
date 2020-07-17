def ch(x):
  def p(n):
    return (x % n == 0)
  return ('FizzBuzz' if p(15) else 'Fizz' if p(3) else 'Buzz' if p(5) else x)

print(list(map(ch, range(1,101))))
