(display

((((lambda (f)
   ((lambda (x)
      (f (lambda (y)
           ((x x) y))))
    (lambda (x)
      (f (lambda (y)
           ((x x) y))))))
   (lambda (g)
     (lambda (n)
       (lambda (r)
         (cond ((= n 0) r)
	       (else
	         ((g (- n 1))
		  (cons n r))))))))
  10)
 '())

) (newline)

(display

(((lambda (f) (f f))
  (lambda (g)
    (lambda (n r)
      (cond ((= n 0) r)
            (else ((g g) (- n 1)
                         (cons n r)))))))
 10 '())

) (newline)
