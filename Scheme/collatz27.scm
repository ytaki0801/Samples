(display
 (((lambda (u) (u u))
   (lambda (u)
     (lambda (n)
       (cond ((= n 1) '(1))
	     ((= (modulo n 2) 1)
	      (cons n ((u u) (+ (* n 3) 1))))
	     (else
	      (cons n ((u u) (/ n 2))))))))
  27)) (newline)
