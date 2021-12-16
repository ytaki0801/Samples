(use srfi-1)

(define (myreverse a)
  (unfold-right null? (^x (car x)) (^x (cdr x)) a))
(print (myreverse '(1 2 3 4 5))) ; => (5 4 3 2 1)

(define (myappend a b)
  (unfold-right null? (^x (car x)) (^x (cdr x)) (myreverse a) b))
(print (myappend '(a b c) '(x y z))) ; => (a b c x y z)

(define (mymap1 f s)
  (unfold-right null? (^x (f (car x))) (^x (cdr x)) (myreverse s)))
(print (mymap1 (^x (+ x 1)) '(10 20 30 40 50))) ; => (11 21 31 41 51)

(define (myiota c . sd)
  (let ((s (if (null? sd) 0 (car sd)))
        (d (if (or (null? sd) (null? (cdr sd))) 1 (cadr sd))))
    (myreverse (unfold-right (^x (> x (- c 1)))
                             (^x (+ (* x d) s))
                             (^x (+ x 1)) 0))))
(print (myiota 6)) ; => (0 1 2 3 4 5)
(print (myiota 6 11)) ; => (11 12 13 14 15 16)
(print (myiota 6 1 2)) ; => (1 3 5 7 9 11)

(define (myfind p s)
  (let ((r (find-tail p s)))
    (if r (car r) r)))
(print (myfind (^x (eq? x 'c)) '(a b c d e))) ; => c
(print (myfind (^x (eq? x 'z)) '(a b c d e))) ; => #f

(define (mymember e s p)
  (find-tail (^x (p x e)) s))
(print (mymember 'c '(a b c d e) eq?)) ; => (c d e)
(print (mymember 'z '(a b c d e) eq?)) ; => #f

(define (myassoc k al p)
  (car (find-tail (^x (p (car x) k)) al)))
(print (myassoc 'b '((a . 1) (b . 2) (c . 3) (b . 4) (e . 5)) eq?)) ; => (b . 2)

(define (myfilter p s)
  (unfold-right not (^x (car x)) (^x (find-tail p (cdr x)))
                (find-tail p (myreverse s))))
(print (myfilter even? (myiota 10))) ; => (0 2 4 6 8)
(print (myfilter even? (myiota 6 1 2))) ; => ()

