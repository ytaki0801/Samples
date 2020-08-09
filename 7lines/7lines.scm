; 7 lines interpreter derived from:
; http://matt.might.net/articles/implementing-a-programming-language/
; In:  (((/ f . (/ x . (f x))) (/ g . g )) (/ a . a))
; Out: ((/ a . a))
(define (eval7 e env)
  (cond ((symbol? e)      (cadr (assq e env)))
        ((eq? (car e) '/) (cons e env))
        (else             (apply7 (eval7 (car  e) env)
                                  (eval7 (cadr e) env)))))
(define (apply7 f x)
  (eval7 (cddr (car f))
         (cons (list (cadr (car f)) x)
               (cdr f))))
(display (eval7 (read) '())) (newline)
