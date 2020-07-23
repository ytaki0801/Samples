(define exec1 (lambda (x y) (x)))
(define exec2 (lambda (x y) (y)))

(exec1 (lambda () (display "exec1"))
       (lambda () (display "exec2")))
; => exec1
(exec2 (lambda () (display "exec1" ))
       (lambda () (display "exec2")))
; => exec2

;;;;
(define NGN (lambda (x) (cond ((negative? x) exec1) (else exec2))))
;;;;

(define den (lambda (c) (c (lambda () exec2) (lambda () exec1))))
(define coj (lambda (c1 c2) (c1 (lambda () c2) (lambda () exec2))))
(define dij (lambda (c1 c2) (c1 (lambda () exec1) (lambda () c2))))

(define gtn (lambda (a b) ((NGN (- b a))
                            (lambda () exec1)
                            (lambda () exec2))))
(define ltn (lambda (a b) ((gtn b a)
                            (lambda () exec1)
                            (lambda () exec2))))
(define eqn (lambda (a b) ((coj (den (ltn a b))
                                (den (gtn a b)))
                            (lambda () exec1)
                            (lambda () exec2))))

(define a 10)
(define b 20)
((ltn a b)
  (lambda () (display "true" ))
  (lambda () (display "false")))
; => false

(define fib
  (lambda (x f1 f2)
    ((eqn x 1)
     (lambda () f1)
     (lambda () (fib (- x 1) f2 (+ f1 f2))))))
(display (fib 50 0 1))    ; => 7778742049
