(use srfi-1)

(define (myreverse a)
  (unfold-right null? (^x (car x)) (^x (cdr x)) a))
(print (myreverse '(1 2 3 4 5))) ; => (5 4 3 2 1)

(define (myappend a b)
  (unfold-right null? (^x (car x)) (^x (cdr x)) (myreverse a) b))
(myappend '(a b c) '(x y z)) ; => (a b c x y z)

(define (mymap1 f s)
  (unfold-right null? (^x (f (car x))) (^x (cdr x)) (myreverse s)))
(mymap1 (^x (+ x 1)) '(10 20 30 40 50)) ; => (11 21 31 41 51)

(define (myrange s e d)
  (myreverse (unfold-right (^x (> x (- e 1))) identity (^x (+ x d)) s)))
(myrange 11 17 1) ; => (11 12 13 14 15 16)

(define (myfind p s)
  (let ((r (find-tail p s)))
    (if r (car r) r)))
(myfind (^x (eq? x 'c)) '(a b c d e)) ; => c
(myfind (^x (eq? x 'z)) '(a b c d e)) ; => #f

(define (mymember e s p)
  (find-tail (^x (p x e)) s))
(mymember 'c '(a b c d e) eq?) ; => (c d e)
(mymember 'z '(a b c d e) eq?) ; => #f

(define (myassoc k al p)
  (car (find-tail (^x (p (car x) k)) al)))
(myassoc 'b '((a . 1) (b . 2) (c . 3) (b . 4) (e . 5)) eq?) ; => (b . 2)

(define (myfilter p s)
  (unfold not (^x (car x)) (^x (find-tail p (cdr x))) (find-tail p s)))
(myfilter even? (myrange 0 10 1)) ; => (0 2 4 6 8)
(myfilter even? (myrange 1 12 2)) ; => ()
