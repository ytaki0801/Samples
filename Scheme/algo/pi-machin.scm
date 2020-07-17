;;;;
;;;; pi-machine.scm
;;;;
;;;; Calculating Pi by Machin Method
;;;;

(define loop
  (lambda (last p t k f c)
    (cond ((equal? last p) p)
	  (else
	   (loop p (f p (/ t k)) (/ t c) (+ k 2) f c)))))

(let ((p (loop 0 3.2 -0.128 3 + -25)))
  (loop p (- p (/ 4.0 239.0)) (/ (/ 4.0 239.0) -57121) 3 - -57121))
