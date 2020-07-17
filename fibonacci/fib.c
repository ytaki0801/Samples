#include <stdio.h>

// #define NOT_TAILRECUR

#ifdef NOT_TAILRECUR
unsigned long long fib(int x)
{
  if (x == 0)
    return (0);
  else
  if (x == 1)
    return (1);
  else
    return (fib(x-1) + fib(x-2));
}
#else
unsigned long long fib_r(
  int x,
  unsigned long long a,
  unsigned long long b)
{
  if (x == 0)
    return (a);
  else
    return (fib_r(x-1, b, a+b));
}
unsigned long long fib(int x)
{
  return (fib_r(x, 0, 1));
}
#endif

int main(void)
{
  for (int n = 0; n < 45; n++)
    printf("%llu ", fib(n));
  printf("\n");
  return (0);
}
