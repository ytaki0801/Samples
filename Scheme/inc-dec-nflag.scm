;;;; increment, decrement, negative-flag
(define inc (lambda (x) (+ x  1)))
(define dec (lambda (x) (+ x -1)))
(define nn? negative?)
;;;;


(define den (lambda (c1) (cond (c1 #f) (else #t))))
(define coj (lambda (c1 c2) (cond (c1 c2) (else #f))))
(define dij (lambda (c1 c2) (cond (c1 #t) (else c2))))

(define np? (lambda (x) (coj (den (nn? x)) (den (nn? (dec x))))))
(define nz? (lambda (x) (coj (den (np? x)) (den (nn? x)))))

(define add
  (lambda (x y)
    (cond ((np? y) (add (inc x) (dec y)))
          ((nn? y) (add (dec x) (inc y)))
          (else x))))

(define sub
  (lambda (x y)
    (cond ((np? y) (sub (dec x) (dec y)))
          ((nn? y) (sub (inc x) (inc y)))
          (else x))))

(define mul-iter
  (lambda (x y r)
    (cond ((nz? y) r)
          (else (mul-iter x (dec y) (add r x))))))
(define mul
  (lambda (x y)
    (cond ((np? y) (mul-iter x y 0))
          ((np? x) (mul-iter y x 0))          
          (else (mul-iter (sub 0 x) (sub 0 y) 0)))))

(define div-iter
  (lambda (x y r)
    (cond ((nn? x) (dec r)) ((nz? x) r)
          (else (div-iter (sub x y) y (inc r))))))
(define div
  (lambda (x y)
    (cond ((coj (np? x) (np? y)) (div-iter x y 0))
          ((coj (nn? x) (np? y)) (mul -1 (div-iter (sub 0 x) y 0)))
          ((coj (np? x) (nn? y)) (mul -1 (div-iter x (sub 0 y) 0)))
          (else (div-iter (sub 0 x) (sub 0 y) 0)))))
(define mdl (lambda (x y) (sub x (mul(div x y) y)))) ; positive only

(define ne? (lambda (x y) (nz? (sub x y))))


;;;; FizzBuzz 
(define d (lambda (x n) (ne? (mdl x n) 0)))
(define p display)
(define c
  (lambda (x)
    (cond ((d x 15) (p "FizzBuzz "))
          ((d x  3) (p "Fizz "))
          ((d x  5) (p "Buzz "))
          (else (p x) (p " ")))))
(define fb
  (lambda (x) 
    (cond ((ne? x 0))
          (else (fb (dec x))
                (c x)))))
(fb 100)