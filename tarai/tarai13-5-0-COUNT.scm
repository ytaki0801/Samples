(define t
  (lambda (a b c)
    (set! COUNT (+ COUNT 1))
    (if (< b a)
        (t (t (- a 1) b c)
           (t (- b 1) c a)
           (t (- c 1) a b))
          b)))

(define COUNT 0)
(display (t 13 5 0)) (newline)
(display COUNT) (newline)

