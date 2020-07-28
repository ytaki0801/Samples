;;;; Church booleans
(define gtn
  (lambda (a b)
    (cond ((> a b) (lambda (x y) (x)))
          (else    (lambda (x y) (y))))))
((gtn 20 30)
 (lambda () (display "20 > 30" ))
 (lambda () (display "20 <= 30")))
; => "20 <= 30"
(newline)

;;;; Church numerals
(define  zero (lambda (f) (lambda (x) x)))
(define   one (lambda (f) (lambda (x) (f x))))
(define   two (lambda (f) (lambda (x) (f (f x)))))
(define three (lambda (f) (lambda (x) (f (f (f x))))))
(define  four (lambda (f) (lambda (x) (f (f (f (f x)))))))
(define ToINT (lambda (ch) ((ch (lambda (x) (+ x 1))) 0)))
(display (ToINT  zero))    ; => 0
(display (ToINT   one))    ; => 1
(display (ToINT   two))    ; => 2
(display (ToINT three))    ; => 3
(display (ToINT  four))    ; => 4
(newline)
(define ChINC (lambda (ch) (lambda (f) (lambda (x) (f ((ch f) x))))))
(display (ToINT (ChINC   two)))    ; => 3
(display (ToINT (ChINC   one)))    ; => 2
(display (ToINT (ChINC three)))    ; => 4
(newline)
(define ChADD (lambda (ch1 ch2) ((ch2 ChINC) ch1)))
(display (ToINT (ChADD one three)))    ; => 1 + 3 = 4
(display (ToINT (ChADD four zero)))    ; => 4 + 0 = 4
(display (ToINT (ChADD three two)))    ; => 3 + 2 = 5
(newline)
(define ChDEC (lambda (ch) (lambda (f) (lambda (x) (((ch (lambda (g) (lambda (h) (h (g f))))) (lambda (u) x)) (lambda (u) u))))))
(display (ToINT (ChDEC three)))    ; => 2
(display (ToINT (ChDEC   one)))    ; => 0
(display (ToINT (ChDEC  four)))    ; => 3
(newline)
(define ChSUB (lambda (ch1 ch2) ((ch2 ChDEC) ch1)))
(display (ToINT (ChSUB three   one)))    ; => 3 - 1 = 2
(display (ToINT (ChSUB  four   one)))    ; => 4 - 1 = 3
(display (ToINT (ChSUB  four three)))    ; => 4 - 3 = 1
(newline)
(define ChMUL (lambda (ch1 ch2) (lambda (f) (ch2 (ch1 f)))))
(display (ToINT (ChMUL  two three)))    ; => 2 * 3 = 6
(display (ToINT (ChMUL four three)))    ; => 4 * 3 = 12
(newline)
(define ChPOW (lambda (ch1 ch2) (ch2 ch1)))
(display (ToINT (ChPOW two three)))    ; => 2^3 = 8
(display (ToINT (ChPOW two  four)))    ; => 2^4 = 16
(display (ToINT (ChPOW one  four)))    ; => 1^4 = 1
(newline)

;;;; loop, Y combinator, Z combinator
; [loop] ((lambda (x) ((x x))) (lambda (x) ((x x)))))
; [Y comibator] (lambda (f) ((lambda (x) (f ((x x))) (lambda (x) (f ((x x)))))))
; [Z combinator]
(display
 (((lambda (f)
     ((lambda (x)
       (f (lambda (y)
            ((x x) y))))
      (lambda (x)
        (f (lambda (y)
             ((x x) y))))))
   (lambda (g)
     (lambda (n)
       (cond ((= n 0) 1) (else (* n (g (- n 1))))))))
  5))
; => 120
(newline)
(define Z (lambda (f) ((lambda (x) (f (lambda (y) ((x x) y)))) (lambda (x) (f (lambda (y) ((x x) y)))))))
(define fact (Z (lambda (g) (lambda (n) (if (= n 0) 1 (* (g (- n 1)) n))))))
(display (fact 5))    ; => 120
(newline)
(define fib (Z (lambda (g) (lambda (n) (lambda (f1) (lambda (f2) (if (= n 0) f1 (((g (- n 1)) f2) (+ f1 f2)))))))))
(display (((fib 40) 0) 1))
(newline)
