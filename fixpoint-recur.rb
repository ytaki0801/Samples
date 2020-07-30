def fib(n,f1,f2) ; if n == 0 then ; f1 ; else ; fib(n-1, f2, f1+f2) ; end ; end
puts fib(50,0,1)    # => 12586269025

g = -> (f) { f.( -> (y) { g.(f).(y) }) }
puts g.(-> (fib) { -> (n) { -> (f1) { -> (f2) { n == 0 ? f1 : fib.(n-1).(f2).(f1+f2) } } } }).(50).(0).(1)
# => 12586269025

