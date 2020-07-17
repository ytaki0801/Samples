;;;;
;;;; filter.scm
;;;;
;;;; 高階関数(higher-order function)の定義例
;;;;

(define filter
  (lambda (p? x)
    (cond ((null? x) ())
	  ((p? (car x))
	   (cons (car x) (filter p? (cdr x))))
	  (else (filter p? (cdr x))))))

; (filter negative? '(10 -2 23 -4))
; (filter positive? '(10 -2 23 -4))
; (filter (lambda (x) (and (> x -3) (< x 20))) '(10 -2 23 -4))

; (map sqrt '(2 3 4))
; (map (lambda (x) (+ x 1)) '(2 3 4))
; (for-each (lambda (x) (print x "'s")) '("apple" "orange" "banana"))
