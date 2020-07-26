(define Z
  (lambda (p)
    ((lambda (f)
      (p (lambda (x)
           ((f f) x))))
     (lambda (f)
       (p (lambda (x)
            ((f f) x)))))))
(define fact
  (lambda (f)
    (lambda (x)
      (cond ((= x 0) 1) (else (* x (f (- x 1))))))))
(display ((Z fact) 5))    ; => 120

(display
 (((lambda (p)
     ((lambda (f)
       (p (lambda (x)
            ((f f) x))))
      (lambda (f)
        (p (lambda (x)
             ((f f) x))))))
   (lambda (f)
     (lambda (x)
       (cond ((= x 0) 1) (else (* x (f (- x 1))))))))
  5))
; => 120
