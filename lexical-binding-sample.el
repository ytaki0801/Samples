;;;; for GNU Emacs 24.1 and later
(setq lexical-binding t)
(funcall (funcall (lambda (x) (lambda (y) (+ x y))) 10) 20)
; => 30
