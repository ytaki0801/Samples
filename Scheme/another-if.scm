(define exec1 (lambda (x y) (x)))
(define exec2 (lambda (x y) (y)))

(exec1 (lambda () (display "exec1"))
       (lambda () (display "exec2")))
; => exec1
(exec2 (lambda () (display "exec1" ))
       (lambda () (display "exec2")))
; => exec2

(define gtn (lambda (a b) (cond ((> a b) exec1) (else exec2))))
(define ltn (lambda (a b) (cond ((< a b) exec1) (else exec2))))
(define eqn (lambda (a b) (cond ((= a b) exec1) (else exec2))))

(define a 10)
(define b 20)
((gtn a b)
  (lambda () (display "true" ))
  (lambda () (display "false")))
; => false

(define fib
  (lambda (x f1 f2)
    ((eqn x 1)
     (lambda () f1)
     (lambda () (fib (- x 1) f2 (+ f1 f2))))))
(display (fib 50 0 1))
