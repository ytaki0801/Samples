;;;; fixpoint combinator
(define fix (lambda (f) (f (lambda (x) (display x) (display " ") ((fix f) x)))))
(define fibfix (fix (lambda (g) (lambda (n) (lambda (f1) (lambda (f2) (if (= n 0) f1 (((g (- n 1)) f2) (+ f1 f2)))))))))
(display (((fibfix 40) 0) 1))    ; => 102334155
(newline)
