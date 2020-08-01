def fix[T1, T2](f: (T1 => T2) => (T1 => T2))(x: T1): T2 = f(fix(f))(x)

fix[BigInt,(BigInt => (BigInt => BigInt))](fib => n => f1 => f2 => if (n == 0) f1 else fib(n-1)(f2)(f1+f2))(50)(0)(1)
// res0: BigInt = 12586269025
(0 to 10).map(x => fix[Int,(Int => (Int => Int))](fib => n => f1 => f2 => if (n == 0) f1 else fib(n-1)(f2)(f1+f2))(x)(0)(1))
// res1: scala.collection.immutable.IndexedSeq[Int] = Vector(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55)
(0 to 50 by 10).map(x => fix[BigInt,(BigInt => (BigInt => BigInt))](fib => n => f1 => f2 => if (n == 0) f1 else fib(n-1)(f2)(f1+f2))(x)(0)(1)) 
// res2: scala.collection.immutable.IndexedSeq[BigInt] = Vector(0, 55, 6765, 832040, 102334155, 12586269025)
