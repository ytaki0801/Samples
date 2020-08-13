(define (fix f) (f (lambda (x) ((fix f) x))))

(display
  ((((fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n)
            (if (= n 0) f1 (((fib f2) (+ f1 f2)) (- n 1))))))))
     0) 1) 40))
(newline)
; => 102334155

(display
  (map
    (((fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n)
             (if (= n 0) f1 (((fib f2) (+ f1 f2)) (- n 1))))))))
      0) 1)
    (iota 11)))
(newline)
; => (0 1 1 2 3 5 8 13 21 34 55)

; required SRFI 1 for iota
(display
  (map
    (((fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n)
             (if (= n 0) f1 (((fib f2) (+ f1 f2)) (- n 1))))))))
      0) 1)
    (iota 6 0 10)))
(newline)
; => (0 55 6765 832040 102334155 12586269025)
