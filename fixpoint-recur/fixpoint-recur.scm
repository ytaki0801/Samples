(define (fix f) (f (lambda (x) ((fix f) x))))

(print ((((fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n) (if (= n 0) f1 (((fib f2) (+ f1 f2)) (- n 1)))))))) 0) 1) 40))
(print (map (((fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n) (if (= n 0) f1 (((fib f2) (+ f1 f2)) (- n 1)))))))) 0) 1) (iota 11)))
(print (map (((fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n) (if (= n 0) f1 (((fib f2) (+ f1 f2)) (- n 1)))))))) 0) 1) (iota 6 0 10)))

