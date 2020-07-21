(define wh
  (lambda (c t f)
    (cond (c (t)) (else (f)))))

(define a 20)
(define b 10)
(wh (< a b) (lambda () (display "<"))
            (lambda () (display ">")))
