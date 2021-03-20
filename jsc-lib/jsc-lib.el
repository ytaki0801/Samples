(defvar jsc-width  400)
(defvar jsc-height 400)

(defun r2a-w (n) (+ (/ jsc-width 2) (* (/ jsc-width 2) n)))
(defun r2a-h (n) (- (/ jsc-height 2) (* (/ jsc-height 2) n)))
;(defun a2r-w (n) (/ (- n (/ jsc-width 2.0)) (/ jsc-width 2.0)))
;(defun a2r-h (n) (/ (- (/ jsc-height 2.0) n) (/ jsc-height 2.0)))

(defmacro ct-2To (c)
  (let* ((fc (symbol-name c))
	 (fn (intern (concat "ct-" fc "to")))
	 (fj (concat "ct." fc "To(")))
    `(defun ,fn (v)
       (concat ,fj
	       (number-to-string (r2a-w (car v))) ","
	       (number-to-string (r2a-h (cadr v))) ");\n"))))
(ct-2To move)
(ct-2To line)

(defun ct-bezierto (vs)
  (let ((v1 (car vs)) (v2 (cadr vs)) (v3 (caddr vs)))
    (concat
     "ct.bezierCurveTo("
     (number-to-string (r2a-w (car  v1))) ","
     (number-to-string (r2a-h (cadr v1))) ","
     (number-to-string (r2a-w (car  v2))) ","
     (number-to-string (r2a-h (cadr v2))) ","
     (number-to-string (r2a-w (car  v3))) ","
     (number-to-string (r2a-h (cadr v3)))
     ");\n")))

(defun jsc (com &rest args)
  (if (eq com 'html)
      (let ((fn (concat
		 (file-name-base (buffer-name))
		 ".html"))
	    (cb (current-buffer)))
	(switch-to-buffer fn) (erase-buffer)
	(insert
	 (concat
	  "<!DOCTYPE html>\n"
	  "<html><body onload=\"draw()\">\n"
	  "<canvas id=\"mcv\"\n"
	  "width=\""
	  (number-to-string jsc-width)  "\" "
	  "height=\""
	  (number-to-string jsc-height) "\">\n"
	  "</canvas>\n"
	  "<script>\n"
	  "function draw(){\n"
	  "var d = document;\n"
	  "var cv = d.querySelector('#mcv');\n"
	  "var ct = cv.getContext('2d');\n"
	  (mapconcat 'identity args "")
	  "}\n"
	  "</script>\n"
	  "</body></html>"))
	(write-file fn nil)
	(switch-to-buffer cb))
    (let ((f (caar args)) (r (cdar args)))
      (concat
       "ct.beginPath();\n"
       (ct-moveto f)
       (mapconcat
	(cond ((eq com 'line)   'ct-lineto)
	      ((eq com 'bezier) 'ct-bezierto))
	r "")
       "ct.stroke();\n"))))
