;;;; inc, dec, ndef for Minimum Scheme
(define inc (lambda (n) (+ n 1)))
(define dec (lambda (n) (- n 1)))
(define ndef (lambda (t f) (lambda (n) (cond ((negative? n) t) (else f)))))
;;;;


; #t, #f, negative?
(define exec1 (lambda (x y) (x)))
(define exec2 (lambda (x y) (y)))
(define ngn (ndef exec1 exec2))

; not, and, or
(define den (lambda (c) (c (lambda () exec2) (lambda () exec1))))
(define coj (lambda (c1 c2) (c1 (lambda () c2) (lambda () exec2))))
(define dij (lambda (c1 c2) (c1 (lambda () exec1) (lambda () c2))))

; postive?, zero?
(define pon (lambda (x) (coj (den (ngn x)) (den (ngn (dec x))))))
(define zen (lambda (x) (coj (den (pon x)) (den (ngn x)))))

; +, -, *, /, modulo
(define add
  (lambda (x y)
    ((pon y)
     (lambda () (add (inc x) (dec y)))
     (lambda () ((ngn y)
                 (lambda () (add (dec x) (inc y)))
                 (lambda () x))))))
(define sub
  (lambda (x y)
    ((pon y)
     (lambda () (sub (dec x) (dec y)))
     (lambda () ((ngn y)
                 (lambda () (sub (inc x) (inc y)))
                 (lambda () x))))))
(define mul-iter
  (lambda (x y r)
    ((zen y)
     (lambda () r)
     (lambda () (mul-iter x (dec y) (add r x))))))
(define mul
  (lambda (x y)
    ((pon y)
     (lambda () (mul-iter x y 0))
     (lambda () ((pon x)
                 (lambda () (mul-iter y x 0))
                 (lambda () (mul-iter (sub 0 x) (sub 0 y) 0)))))))
(define div-iter
  (lambda (x y r)
    ((ngn x)
     (lambda () (dec r))
     (lambda () ((zen x)
                 (lambda () r)
                 (lambda () (div-iter (sub x y) y (inc r))))))))
(define div
  (lambda (x y)
    ((coj (pon x) (pon y))
     (lambda () (div-iter x y 0))
     (lambda () ((coj (ngn x) (pon y))
                 (lambda () (mul -1 (div-iter (sub 0 x) y 0)))
                 (lambda () ((coj (pon x) (ngn y))
                             (lambda () (mul -1 (div-iter x (sub 0 y) 0)))
                             (lambda () (div-iter (sub 0 x) (sub 0 y) 0)))))))))
(define mdl (lambda (x y) (sub x (mul (div x y) y))))

; >, <, =
(define gtn
  (lambda (a b)
    ((ngn (sub b a))
     (lambda () exec1)
     (lambda () exec2))))
(define ltn
  (lambda (a b)
    ((gtn b a)
     (lambda () exec1)
     (lambda () exec2))))
(define eqn
  (lambda (a b)
    ((coj (den (ltn a b)) (den (gtn a b)))
     (lambda () exec1)
     (lambda () exec2))))

; cons, car, cdr
(define pair (lambda (a b) (lambda (f) (f a b))))
(define pa (lambda (f) (f (lambda (a b) a))))
(define pb (lambda (f) (f (lambda (a b) b))))


;;;; Tests

; negative?, positive?, zero? => 122212221
(display ((ngn -1) (lambda () 1) (lambda () 2)))
(display ((ngn  1) (lambda () 1) (lambda () 2)))
(display ((ngn  0) (lambda () 1) (lambda () 2)))
(display ((pon -1) (lambda () 1) (lambda () 2)))
(display ((pon  1) (lambda () 1) (lambda () 2)))
(display ((pon  0) (lambda () 1) (lambda () 2)))
(display ((zen -1) (lambda () 1) (lambda () 2)))
(display ((zen  1) (lambda () 1) (lambda () 2)))
(display ((zen  0) (lambda () 1) (lambda () 2)))
(display "\n")

; not, and, or => 2112221112
(display ((den (zen 0)) (lambda () 1) (lambda () 2)))
(display ((den (zen 1)) (lambda () 1) (lambda () 2)))
(display ((coj (zen 0) (zen 0)) (lambda () 1) (lambda () 2)))
(display ((coj (zen 0) (zen 1)) (lambda () 1) (lambda () 2)))
(display ((coj (zen 1) (zen 0)) (lambda () 1) (lambda () 2)))
(display ((coj (zen 1) (zen 1)) (lambda () 1) (lambda () 2)))
(display ((dij (zen 0) (zen 0)) (lambda () 1) (lambda () 2)))
(display ((dij (zen 0) (zen 1)) (lambda () 1) (lambda () 2)))
(display ((dij (zen 1) (zen 0)) (lambda () 1) (lambda () 2)))
(display ((dij (zen 1) (zen 1)) (lambda () 1) (lambda () 2)))
(display "\n")

; +, -, *, /, modulo => 73-3-7-3-77310-10-10102-2-2221
(display (add  2  5))
(display (add -2  5))
(display (add  2 -5))
(display (add -2 -5))
(display (sub  2  5))
(display (sub -2  5))
(display (sub  2 -5))
(display (sub -2 -5))
(display (mul  2  5))
(display (mul -2  5))
(display (mul  2 -5))
(display (mul -2 -5))
(display (div  7  3))
(display (div -7  3))
(display (div  7 -3))
(display (div -7 -3))
(display (mdl  8  3))
(display (mdl  7  3))
(display "\n")

; >, <, =    => 212122221
(display ((gtn 2 3) (lambda () 1) (lambda () 2)))
(display ((gtn 3 2) (lambda () 1) (lambda () 2)))
(display ((gtn 2 2) (lambda () 1) (lambda () 2)))
(display ((ltn 2 3) (lambda () 1) (lambda () 2)))
(display ((ltn 3 2) (lambda () 1) (lambda () 2)))
(display ((ltn 2 2) (lambda () 1) (lambda () 2)))
(display ((eqn 2 3) (lambda () 1) (lambda () 2)))
(display ((eqn 3 2) (lambda () 1) (lambda () 2)))
(display ((eqn 2 2) (lambda () 1) (lambda () 2)))
(display "\n")

; cons, car, cdr => 1020
(display (pa (pair 10 20)))
(display (pb (pair 10 20)))
(display "\n")

; Fibonacci stream => 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 
(define make-fib
  (lambda (f1 f2)
    (pair f1
          (lambda () (make-fib f2 (add f1 f2))))))
(define disp-list
  (lambda (s n)
    ((zen n)
     (lambda () (display "\n"))
     (lambda () (display (pa s))
                (display " ")
                (disp-list ((pb s)) (dec n))))))
(define fibs (make-fib 0 1))
(disp-list fibs 20)

; FizzBuzz => 1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz Fizz 22 23 Fizz Buzz 26 Fizz 28 29 FizzBuzz 31 32 Fizz 34 Buzz Fizz 37 38 Fizz Buzz 41 Fizz 43 44 FizzBuzz 46 47 Fizz 49 Buzz
(define d (lambda (x n) (eqn (mdl x n) 0)))
(define p display)
(define c
  (lambda (x)
    ((d x 15)
     (lambda () (p "FizzBuzz "))
     (lambda () ((d x 3)
                 (lambda () (p "Fizz "))
                 (lambda () ((d x 5)
                             (lambda () (p "Buzz "))
                             (lambda () (p x) (p " ")))))))))
(define fb
  (lambda (x) 
    ((eqn x 0)
     (lambda () )
     (lambda () (fb (dec x)) (c x)))))
(fb 50)
(display "\n")
