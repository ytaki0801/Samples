(define threetimes
  (lambda (f)
    (lambda (x y)
      (print (f (f (f x y) y) y)))))

(define f (lambda (x y) (+ (* 2 x) y)))
((threetimes f) 10 5)
; => (f (f (f 10 5) 5) 5)
; => (+ (* 2 (+ (* 2 (+ (* 2 10) 5)) 5)) 5) => "115"

(define threetimes_message
  (lambda (f . mes)
    (lambda (x y)
      (if (not (null? mes)) (display (car mes)))
      (print (f (f (f x y) y) y)))))

((threetimes_message f "Result = ") 10 5)
; => "Result = 115"
((threetimes_message f) 10 5)
; => "115"


(define args-10-5 (lambda (f) (f 10 5)))
(define f
  (lambda (x y)
    (display "x = ") (display x)
    (display ", y = ") (print y)))
(args-10-5 f) ; => "x = 10, y = 5"

(define f (lambda (x y z w) (+ (* 4 x) (* 3 y) (* 2 z) w)))
(f 2 3 4 5) ; => 30

(define f
  (lambda (x) (lambda (y) (lambda (z) (lambda (w)
    (+ (* 4 x) (* 3 y) (* 2 z) w))))))
((((f 2) 3) 4) 5) ; => 30

(define unfold
  (lambda (pred f update seed)
    (cond ((pred seed) '())
          (else
           (cons (f seed)
                 (unfold pred f update (update seed)))))))
(unfold (lambda (x) (> x 10)) square (lambda (x) (+ x 1)) 1)
; => (1 4 9 16 25 36 49 64 81 100)
