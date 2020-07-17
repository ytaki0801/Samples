(define prime?
  (lambda (x)
    (let loop ((i 2))
      (cond ((>= i (+ (/ x 2) 1)) #t)
            ((= (mod x i) 0) #f)
            (else (loop (+ i 1)))))))


(display "x = ? ")
(flush)
(let ((x (read)))
  (let loop ((n 2))
    (cond ((> n x) (display "\n"))
          (else
           (cond ((prime? n) (display n) (display " ")))
           (loop (+ n 1))))))

