fix f = f (fix f)

fix (\fib -> \f1 -> \f2 -> \n -> if n == 0 then f1 else fib f2 (f1+f2) (n-1)) 0 1 40
-- => 102334155
map (fix (\fib -> \f1 -> \f2 -> \n -> if n == 0 then f1 else fib f2 (f1+f2) (n-1)) 0 1) [0..10]
-- => [0,1,1,2,3,5,8,13,21,34,55]
map (fix (\fib -> \f1 -> \f2 -> \n -> if n == 0 then f1 else fib f2 (f1+f2) (n-1)) 0 1) [0,10..50]
-- => [0,55,6765,832040,102334155,12586269025]
