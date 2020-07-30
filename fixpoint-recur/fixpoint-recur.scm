(define (g f) (f (lambda (y) ((g f) y))))
(print ((((g (lambda (fib) (lambda (n) (lambda (f1) (lambda (f2) (if (= n 0) f1 (((fib (- n 1)) f2) (+ f1 f2)))))))) 50) 0) 1))
; => 12586269025
(print (map (lambda (x) ((((g (lambda (fib) (lambda (n) (lambda (f1) (lambda (f2) (if (= n 0) f1 (((fib (- n 1)) f2) (+ f1 f2)))))))) x) 0) 1)) (iota 11)))
; => (0 1 1 2 3 5 8 13 21 34 55)
(print (map (lambda (x) ((((g (lambda (fib) (lambda (n) (lambda (f1) (lambda (f2) (if (= n 0) f1 (((fib (- n 1)) f2) (+ f1 f2)))))))) x) 0) 1)) (iota 6 0 10)))
; => (0 55 6765 832040 102334155 12586269025)
