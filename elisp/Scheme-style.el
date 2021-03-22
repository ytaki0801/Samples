(defmacro define (name &rest body)
  (if (atom name)
      `(setq ,name ,@body)
    `(defun ,(car name) ,(cdr name)
       ,@body)))

(define s '(1 2 3 4 5))
(define (func f x i)
  (while (not (null x))
    (setq i (funcall f (car x) i))
    (setq x (cdr x)))
  i)
(func '+ s 0)
(func '* s 1)
(func 'cons (func 'cons s '())
      '(x y z w v))
