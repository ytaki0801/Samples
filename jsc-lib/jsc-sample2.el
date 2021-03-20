(load-file "./jsc-lib.el")

(defun fgen (f x1 x2 p)
  (let ((r '()) (c x1))
    (while (<= c x2)
      (push (list (/ c 8) (/ (funcall f c) 2)) r)
      (setq c (+ c p)))
    r))

(jsc 'html
     (jsc 'line
	  (fgen
	   'sin
;	   (lambda (x)
;	     (let ((th (* x x)))
;	       (+ (sin th) (cos th))))
	   (- (* 2 pi)) (* 2 pi) 0.05)))
