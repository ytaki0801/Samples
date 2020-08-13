(defun fix (f) (funcall f (lambda (x) (funcall (fix f) x))))

(print
  (funcall (funcall (funcall
    (fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n)
           (if (= n 0) f1 (funcall (funcall (funcall fib f2) (+ f1 f2)) (- n 1))))))))
  0) 1) 40))
; => 102334155

(defun map (f l) (if (null l) '() (cons (funcall f (car l)) (map f (cdr l)))))
(print
  (map (funcall (funcall
    (fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n)
           (if (= n 0) f1 (funcall (funcall (funcall fib f2) (+ f1 f2)) (- n 1))))))))
    0) 1) '(0 1 2 3 4 5 6 7 8 9 10)))
; => (0 1 1 2 3 5 8 13 21 34 55)
(print
  (map (funcall (funcall
    (fix (lambda (fib) (lambda (f1) (lambda (f2) (lambda (n)
           (if (= n 0) f1 (funcall (funcall (funcall fib f2) (+ f1 f2)) (- n 1))))))))
    0) 1) '(0 10 20 30 40 50)))
; => (0 55 6765 832040 102334155 12586269025)

