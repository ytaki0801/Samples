; The Lisp defined in McCarthy's 1960 paper,
; translated into Scheme, derived from jmc.lisp.
; Assumes only quote, pair?, eq?, cons, car, cdr, cond.

(define (atom. x)
  (and. (not. (null. x)) (not. (pair? x))))

(define (null. x)
  (eq? x '()))

(define (and. x y)
  (cond (x (cond (y #t) (else #f)))
        (else #f)))

(define (not. x)
  (cond (x #f)
        (else #t)))

(define (append. x y)
  (cond ((null. x) y)
        (else (cons (car x) (append. (cdr x) y)))))

(define (list. x y)
  (cons x (cons y '())))

(define (pair. x y)
  (cond ((and. (null. x) (null. y)) '())
        ((and. (not. (atom. x)) (not. (atom. y)))
         (cons (list. (car x) (car y))
               (pair. (cdr x) (cdr y))))))

(define (assoc. x y)
  (cond ((eq? (caar y) x) (cadar y))
        (else (assoc. x (cdr y)))))

(define (eval. e a)
  (cond
    ((eq? e '#t) #t)
    ((eq? e '#f) #f)
    ((atom. e) (assoc. e a))
    ((atom. (car e))
     (cond
       ((eq? (car e) 'quote) (cadr e))
       ((eq? (car e) 'pair?) (pair?  (eval. (cadr e) a)))
       ((eq? (car e) 'eq?)   (eq?    (eval. (cadr e) a)
                                     (eval. (caddr e) a)))
       ((eq? (car e) 'car)   (car    (eval. (cadr e) a)))
       ((eq? (car e) 'cdr)   (cdr    (eval. (cadr e) a)))
       ((eq? (car e) 'cons)  (cons   (eval. (cadr e) a)
                                     (eval. (caddr e) a)))
       ((eq? (car e) 'cond)  (evcon. (cdr e) a))
       (else (eval. (cons (assoc. (car e) a) (cdr e)) a))))
    ((eq? (caar e) 'label)
     (eval. (cons (caddar e) (cdr e))
            (cons (list. (cadar e) (car e)) a)))
    ((eq? (caar e) 'lambda)
     (eval. (caddar e)
            (append. (pair. (cadar e) (evlis. (cdr e) a))
                     a)))))

(define (evcon. c a)
  (cond ((eval. (caar c) a)
         (eval. (cadar c) a))
        (else (evcon. (cdr c) a))))

(define (evlis. m a)
  (cond ((null. m) '())
        (else (cons (eval. (car m) a)
                    (evlis. (cdr m) a)))))

