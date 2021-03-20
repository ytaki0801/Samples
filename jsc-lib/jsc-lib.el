(defvar jsc-width  400)
(defvar jsc-height 400)

(defun jsc-html (&rest args)
  (let ((fn (concat (file-name-base (buffer-name)) ".html"))
	(cb (current-buffer)))
    (switch-to-buffer fn) (erase-buffer)
    (insert
     (concat
      "<!DOCTYPE html>\n"
      "<html><body onload=\"draw()\">\n"
      "<canvas id=\"jscid\"\n"
      "width=\""
      (number-to-string jsc-width)  "\" "
      "height=\""
      (number-to-string jsc-height) "\">\n"
      "</canvas>\n"
      "<script>\n"
      "function draw(){\n"
      "var cv = document.querySelector('#jscid');\n"
      "var jsc = cv.getContext('2d');\n"
      (mapconcat 'identity args "")
      "}\n"
      "</script>\n"
      "</body></html>"))
    (write-file fn nil)
    (switch-to-buffer cb)))

(defun r2a-w (n) (+ (/ jsc-width 2) (* (/ jsc-width 2) n)))
(defun r2a-h (n) (- (/ jsc-height 2) (* (/ jsc-height 2) n)))
;(defun a2r-w (n) (/ (- n (/ jsc-width 2.0)) (/ jsc-width 2.0)))
;(defun a2r-h (n) (/ (- (/ jsc-height 2.0) n) (/ jsc-height 2.0)))

(defmacro jsc-2To (c)
  (let* ((fc (symbol-name c))
	 (fn (intern (concat "jsc-" fc)))
	 (fj (concat "jsc." fc "To(")))
    `(defun ,fn (v)
       (concat ,fj
	       (number-to-string (r2a-w (car v))) ","
	       (number-to-string (r2a-h (cadr v))) ");\n"))))
(jsc-2To move)
(jsc-2To line)

(defun jsc-bezier (vs)
  (let ((v1 (car vs)) (v2 (cadr vs)) (v3 (caddr vs)))
    (concat
     "jsc.bezierCurveTo("
     (number-to-string (r2a-w (car  v1))) ","
     (number-to-string (r2a-h (cadr v1))) ","
     (number-to-string (r2a-w (car  v2))) ","
     (number-to-string (r2a-h (cadr v2))) ","
     (number-to-string (r2a-w (car  v3))) ","
     (number-to-string (r2a-h (cadr v3)))
     ");\n")))

(defun jsc (com &rest args)
  (let ((f (caar args)) (r (cdar args)))
    (concat
     "jsc.beginPath();\n"
     (jsc-move f)
     (mapconcat
      (cond ((eq com 'line)   'jsc-line)
	    ((eq com 'bezier) 'jsc-bezier))
      r "")
     "jsc.stroke();\n")))
