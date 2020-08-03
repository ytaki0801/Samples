; Example 1
(define func (lambda (y) (lambda (z) (lambda (w) (lambda (x) (if (> x 0) y (if (< x 0) z w)))))))
(define func1 ((func "positive") "negative"))
(define func2 (func1 "zero"))
(print (func2 1))     ; => positive
(print (func2 -1))    ; => negative
(print (func2 0))     ; => zero
(define func2 (func1 "ゼロ"))
(print (func2 0))     ; => ゼロ
(define T '(3 -2 0 1 -7))
(print (map cons T (map func2 T)))
; => ((3 . positive) (-2 . negative) (0 . ゼロ) (1 . positive) (-7 . negative))
(define (recur f t) (if (null? t) f (recur (f (car t)) (cdr t))))
(print (map cons T (map (recur func '("正" "負" "ゼロ")) T)))
; => ((3 . 正) (-2 . 負) (0 . ゼロ) (1 . 正) (-7 . 負))

; Example 2
(define (is_t t) (lambda (v) (eq? (class-of v) t)))
(define T '(10 "hoge" 20.4 #f "hage"))
(print (map (is_t <string>) T))
; => (#f #t #f #f #t)
(print (map (is_t <integer>) T))
; => (#t #f #f #f #f)

; Example 3
(define func (lambda (x) (lambda (y) (* x y))))
(define fx (func 5))
(print (map fx (iota 10)))          ; => (0 5 10 15 20 25 30 35 40 45)
(define fy (map func (iota 10)))
(print (map (lambda (f) (f 5)) fy)) ; => (0 5 10 15 20 25 30 35 40 45)
