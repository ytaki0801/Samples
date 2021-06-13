(display

(((lambda (g) (g g))
  (lambda (g)
    (lambda (n r)
      (if (eq? n -1) r
	  ((g g) (- n 1)
	   (cons
	    (((lambda (g) (g g))
	      (lambda (g)
		(lambda (n a b)
		  (if (eq? n 0) a
		      ((g g) (- n 1) b (+ a b))))))
	     n 0 1)
	    r))))))
 21 '())

) (newline)

