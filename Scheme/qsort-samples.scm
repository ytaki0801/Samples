(define D '(14 91 26 58 66 87 25 41 72 50 20 9 27 31 12 28 16 99 100 80))

(use srfi-42)
(define qsort1
  (lambda (L)
    (if (null? L) '()
        (let ((p (car L)) (r (cdr L)))
             (append
               (qsort1 (list-ec (: x r) (if (< x p)) x))
               (list p)
               (qsort1 (list-ec (: x r) (if (>= x p)) x)))))))
(display (qsort1 D)) (newline)

(define qsort2
  (lambda (L)
    (if (null? L) '()
        (let ((p (car L)))
             (receive (a b) (partition (lambda (x) (< x p)) (cdr L))
               (append (qsort2 a) (list p) (qsort2 b)))))))
(display (qsort2 D)) (newline)
