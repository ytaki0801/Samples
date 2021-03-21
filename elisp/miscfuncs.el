(setq al '((a . 1) (c . 5) (h . 3)))

(defun alist-search (k vs)
  (cond ((null vs) nil)
	((eq k (caar vs)) (cdar vs))
	(t (alist-search
	    k
	    (cdr vs)))))
(alist-search 'c al)

(defun map1 (f l)
  (if (null l) nil
    (cons (funcall f (car l))
	  (map1 f (cdr l)))))
(map1 'car al)

(defun filter (f l)
  (if (null l) nil
    (let ((r (filter f (cdr l))))
      (if (funcall f (car l))
	  (cons (car l) r) r))))
(defun ch (x) (< (cdr x) 3))
(filter 'ch al)

(defun foldr (f x i)
  (if (null x) i
    (funcall f (car x)
	     (foldr f (cdr x) i))))
(foldr '+ '(1 2 3 4 5) 0)
