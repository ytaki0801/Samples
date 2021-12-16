(define COUNT 0)

(display

(((lambda (g) (g g))
  (lambda (t)
    (lambda (a b c)
      (set! COUNT (+ COUNT 1))
      (if (< b a)
          ((t t) ((t t) (- a 1) b c)
                 ((t t) (- b 1) c a)
                 ((t t) (- c 1) a b))
          b))))
 13 5 0)

) (newline)

(display COUNT)
(newline)

