(define (print x) (display x) (newline))

(define (myunfold-right p f g seed . i)
  (let loop ((e seed) (r (if (null? i) i (car i))))
    (if (p e) r (loop (g e) (cons (f e) r)))))

(define (myfind-tail p a)
  (let loop ((r a))
    (cond ((null? r) #f)
	  ((p (car r)) r)
	  (else (loop (cdr r))))))

(define (myreverse a)
  (myunfold-right null? car cdr a))
(print (myreverse '(1 2 3 4 5))) ; => (5 4 3 2 1)

(define (myappend a b)
  (myunfold-right null? car cdr (myreverse a) b))
(print (myappend '(a b c) '(x y z))) ; => (a b c x y z)

(define (mymap1 f s)
  (myunfold-right null? (lambda (x) (f (car x))) cdr (myreverse s)))
(print (mymap1 (lambda (x) (+ x 1)) '(10 20 30 40 50))) ; => (11 21 31 41 51)

(define (myiota c . sd)
  (let ((s (if (null? sd) 0 (car sd)))
	(d (if (or (null? sd) (null? (cdr sd))) 1 (cadr sd))))
    (myreverse (myunfold-right (lambda (x) (> x (- c 1)))
			       (lambda (x) (+ (* x d) s))
			       (lambda (x) (+ x 1)) 0))))
(print (myiota 6)) ; => (0 1 2 3 4 5)
(print (myiota 6 11)) ; => (11 12 13 14 15 16)
(print (myiota 6 1 2)) ; => (1 3 5 7 9 11)

(define (myfind p s)
  (let ((r (myfind-tail p s)))
    (if r (car r) r)))
(print (myfind (lambda (x) (eq? x 'c)) '(a b c d e))) ; => c
(print (myfind (lambda (x) (eq? x 'z)) '(a b c d e))) ; => #f

(define (mymember e s p)
  (myfind-tail (lambda (x) (p x e)) s))
(print (mymember 'c '(a b c d e) eq?)) ; => (c d e)
(print (mymember 'z '(a b c d e) eq?)) ; => #f

(define (myassoc k al p)
  (car (myfind-tail (lambda (x) (p (car x) k)) al)))
(print (myassoc 'b '((a . 1) (b . 2) (c . 3) (b . 4) (e . 5)) eq?)) ; => (b . 2)

(define (myfilter p s)
  (myunfold-right not car (lambda (x) (myfind-tail p (cdr x)))
                (myfind-tail p (myreverse s))))
(print (myfilter even? (myiota 10))) ; => (0 2 4 6 8)
(print (myfilter even? (myiota 6 1 2))) ; => ()

