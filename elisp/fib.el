(defun fib1 (x)
  (cond ((= x 0) 0)
	((= x 1) 1)
	(t (+ (fib1 (- x 1))
	      (fib1 (- x 2))))))
(fib1 30)

(defun fib2 (x f1 f2)
  (if (= x 0) f1
    (fib2 (- x 1) f2 (+ f1 f2))))
(fib2 43 0 1)

(defun fib3 (x f1 f2)
  (while (>= x 0)
    (setq r  f1
	  f1 f2
	  f2 (+ r f2)
	  x  (- x 1)))
  r)
(fib3 10 0 1)
