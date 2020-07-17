;;;; not tail-recur
;(define fib
;  (lambda (x)
;    (cond ((equal? x 0) 0)
;          ((equal? x 1) 1)
;          (else
;            (+ (fib (- x 1)) (fib (- x 2)))))))

(define fib
  (lambda (x)
    (let loop ((x x) (a 0) (b 1))
      (if (equal? x 0) a (loop (- x 1) b (+ a b))))))

(print (map fib (iota 45)))
