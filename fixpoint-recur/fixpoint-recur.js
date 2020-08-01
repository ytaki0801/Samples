fix = f => f(x => fix(f)(x))

console.log(fix(fib => n => f1 => f2 => n == 0 ? f1 : fib(n-1)(f2)(f1+f2))(50)(0)(1))
// => 12586269025
console.log([...Array(11).keys()].map(x => fix(fib => n => f1 => f2 => n == 0 ? f1 : fib(n-1)(f2)(f1+f2))(x)(0)(1)))
// => [ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 ]
console.log([...Array(6)].map((v,k)=>k*10).map(x => fix(fib => n => f1 => f2 => n == 0 ? f1 : fib(n-1)(f2)(f1+f2))(x)(0)(1)))
// => [ 0, 55, 6765, 832040, 102334155, 12586269025 ]
