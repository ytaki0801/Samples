;;;;
;;;; pi-agm.scm
;;;;
;;;; Calculating Pi by arithmetic-geometric mean
;;;;

(let loop ((i 0) (last 0) (a 1) (b (/ 1 (sqrt 2))) (s 1) (t 4))
  (cond ((equal? i 3)
	 (/ (* (+ a b) (+ a b)) s))
	(else
	 (let ((ad (/ (+ a b) 2)))
	   (loop (+ i 1) a ad (sqrt (* a b))
		 (- s (* t (- ad a) (- ad a))) (* t 2))))))
	       
