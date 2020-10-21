(set 'null (lambda (L) (eq L '())))

(set 'append
  (lambda (L1 L2)
    (if (null L1)
        L2
        (cons (car L1)
              (append (cdr L1) L2)))))

(set 'fold
  (lambda (f n L)
    (if (null L)
        n
	(fold f
              (f (car L) n)
              (cdr L)))))

(set 'reverse
   (lambda (L)
     (fold (lambda (x y) (cons x y))
           '() L)))

(set 'list (lambda x x))

(set 'map
  (lambda (f L)
    (if (null L)
        '()
        (append (list (f (car L)))
                (map f (cdr L))))))

; (map reverse '((a b c) (1 2 3) (hello nice to meet you)))
; => ((c b a) (3 2 1) (you meet to nice hello))

(set 'filter
  (lambda (p L)
    (if (null L)
        '()
        (if (p (car L))
            (cons (car L) (filter p (cdr L)))
            (filter p (cdr L))))))

(set 'assq
  (lambda (L k)
    (if (null L)
        '()
        (if (eq (car (car L)) k)
            (car (cdr (car L)))
            (assq (cdr L) k)))))

; (set 'db
;   '((Sato   (Engl 95) (Math 59) (Chem 72))
;     (Suzuki (Japn 82) (Chem 91) (Expr 79))
;     (Naito  (Math 68) (Japn 77) (Engl 87))))
;
; (filter (lambda (x) x) (map (lambda (x) (assq (cdr x) 'Engl)) db))
; => (95 87)
