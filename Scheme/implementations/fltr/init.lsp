; femtoLisp tiny reduced version, fltr, by TAKIZAWA Yozo
; Derived from https://github.com/JeffBezanson/femtolisp/blob/master/tiny/system.lsp

(set 'list (lambda args args))

(set 'define (macro (name val)
  (list set (list quote name) val)))
(define set! define)

(define if (macro (p . cs)
  (list 'cond (list p (car cs))
              (list 'else
                (cond ((null? (cdr cs)) '#f)
                      (else (car (cdr cs))))))))
(define else #t)

(define f-body
  (lambda (e)
    (cond ((atom? e)        e)
          ((eq? (cdr e) ()) (car e))
          (else             (cons begin e)))))

(define sp '| |)
(define identity (lambda (x) x))
(define null? not)
(define cons? (lambda (x) (not (atom? x))))

(define map1 (lambda (f lst)
  (if (atom? lst) lst
    (cons (f (car lst)) (map1 f (cdr lst))))))

(define map (lambda (f . lsts)
  ((rec map- (lambda (lsts)
     (cond ((null? lsts) (f))
           ((atom? (car lsts)) (car lsts))
           (else (cons (apply f (map1 car lsts))
                       (map- (map1 cdr lsts)))))))
   lsts)))

(define let (macro (binds . body)
  (cons (list 'lambda (map car binds) (f-body body))
        (map cadr binds))))

(define append (lambda lsts
  (cond ((null? lsts) ())
        ((null? (cdr lsts)) (car lsts))
        (else ((rec append2 (lambda (l d)
                                  (if (null? l) d
                                      (cons (car l)
                                      (append2 (cdr l) d)))))
             (car lsts) (apply append (cdr lsts)))))))

(define member (lambda (item lst)
  (cond ((atom? lst) ())
        ((eq? (car lst) item) lst)
        (else (member item (cdr lst))))))

(define =    eq?)
(define eql? eq?)
(define !=   (lambda (a b) (not (eq? a b))))
(define >    (lambda (a b) (< b a)))
(define <=   (lambda (a b) (not (< b a))))
(define >=   (lambda (a b) (not (< a b))))
(define mod  (lambda (x y) (- x (* (/ x y) y))))
(define abs  (lambda (x)   (if (< x 0) (- x) x)))

(define caar  (lambda (x) (car (car x))))
(define cadr  (lambda (x) (car (cdr x))))
(define cdar  (lambda (x) (cdr (car x))))
(define cddr  (lambda (x) (cdr (cdr x))))
(define caaar (lambda (x) (car (car (car x)))))
(define caadr (lambda (x) (car (car (cdr x)))))
(define cadar (lambda (x) (car (cdr (car x)))))
(define caddr (lambda (x) (car (cdr (cdr x)))))
(define cdaar (lambda (x) (cdr (car (car x)))))
(define cdadr (lambda (x) (cdr (car (cdr x)))))
(define cddar (lambda (x) (cdr (cdr (car x)))))
(define cdddr (lambda (x) (cdr (cdr (cdr x)))))

(define equal? (lambda (a b)
  (if (and (cons? a) (cons? b))
      (and (equal? (car a) (car b))
           (equal? (cdr a) (cdr b)))
    (eq? a b))))

(define compare (lambda (a b)
  (cond ((eq? a b) 0)
        ((or (atom? a) (atom? b)) (if (< a b) -1 1))
        (else (let ((c (compare (car a) (car b))))
                (if (not (eq? c 0))
                    c
                    (compare (cdr a) (cdr b))))))))

(define every? (lambda (pred lst)
  (or (atom? lst)
      (and (pred (car lst))
           (every pred (cdr lst))))))

(define any? (lambda (pred lst)
  (and (cons? lst)
       (or (pred (car lst))
           (any pred (cdr lst))))))

(define list? (lambda (a) (or (eq? a ()) (cons? a))))

(define length (lambda (l)
  (if (null? l) 0
      (+ 1 (length (cdr l))))))

(define filter (lambda (pred lst)
  (cond ((null? lst) ())
        ((not (pred (car lst))) (filter pred (cdr lst)))
        (else (cons (car lst) (filter pred (cdr lst)))))))

(define foldr (lambda (f zero lst)
  (if (null? lst) zero
    (f (car lst) (foldr f zero (cdr lst))))))

(define foldl (lambda (f zero lst)
  (if (null? lst) zero
    (foldl f (f (car lst) zero) (cdr lst)))))

(define reverse (lambda (lst) (foldl cons #f lst)))

(define reduce (lambda (f lst)
  ((rec reduce0 (lambda (f zero lst)
     (if (null? lst) zero
         (reduce0 f (f zero (car lst)) (cdr lst)))))
   f (car lst) (cdr lst))))

(define copy-list (lambda (l) (map identity l)))
(define copy-tree (lambda (l)
  (if (atom? l) l
    (cons (copy-tree (car l))
          (copy-tree (cdr l))))))

(define assoc (lambda (item lst)
  (cond ((atom? lst) ())
        ((eq? (caar lst) item) (car lst))
        (else (assoc item (cdr lst))))))
