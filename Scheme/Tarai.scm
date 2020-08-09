(define Tarai
  (lambda (x y z)
    (cond ((<= x y) y)
          (else
            (Tarai (Tarai (- x 1) y z)
                   (Tarai (- y 1) z x)
                   (Tarai (- z 1) x y))))))
(display (Tarai 14 7 0)) (newline)
