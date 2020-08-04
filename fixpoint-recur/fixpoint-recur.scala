def fix[T1, T2](f: (T1 => T2) => (T1 => T2))(x: T1): T2 = f(fix(f))(x)

fix[BigInt,(BigInt => (BigInt => BigInt))](fib => f1 => f2 => n => if (n == 0) f1 else fib(f2)(f1+f2)(n-1))(0)(1)(40)
// => res0: BigInt = 102334155

(0 to 10).map(fix[Int,(Int => (Int => Int))](fib => f1 => f2 => n => if (n == 0) f1 else fib(f2)(f1+f2)(n-1))(0)(1))
// => res1: scala.collection.immutable.IndexedSeq[Int] = Vector(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55)

(0 to 50 by 10).map(fix[BigInt,(BigInt => (Int => BigInt))](fib => f1 => f2 => n => if (n == 0) f1 else fib(f2)(f1+f2)(n-1))(0)(1))
// => res2: scala.collection.immutable.IndexedSeq[BigInt] = Vector(0, 55, 6765, 832040, 102334155, 12586269025)
