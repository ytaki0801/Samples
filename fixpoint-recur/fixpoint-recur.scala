def g[T](f: ((T => T), T) => T, x: T): T = f((y: T) => g(f, y), x)
g[Int]((f, n) => if (n == 0) 1 else n * f(n-1), 5)
