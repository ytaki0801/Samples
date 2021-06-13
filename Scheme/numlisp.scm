(define (numeval e a)
  (if (pair? e)
      (let ((p (car e)) (c (cdr e)))
	(cond ((eq? p 'quote) (car c))
	      ((eq? p '?)
	       (if (eq? (numeval (car c) a) (numeval (cadr c) a))
		   (numeval (caddr c) a) (numeval (cadddr c) a)))
	      ((and (not (pair? p)) (> (string-length (symbol->string p)) 1)
		    (equal? (substring (symbol->string p) 0 1) "^"))
	       (let ((l (symbol->string p)))
		 (list
		  (map (lambda (x) (string->symbol (list->string (list x))))
		       (string->list (substring l 1 (string-length l))))
		  (car c) a)))
	      (else (let ((f (numeval p a))
			  (v (map (lambda (x) (numeval x a)) c)))
		      (if (pair? f)
			  (let ((a (car f)) (g (cadr f)) (e (caddr f)))
			    (numeval g (append (map cons a v) e)))
			  (cond ((eq? f '+) (+ (car v) (cadr v)))
				((eq? f '*) (* (car v) (cadr v)))
				((eq? f '^) (expt (car v) (cadr v)))
				((eq? f '%) (modulo (car v) (cadr v)))
				((eq? f '$) (cons (car v) (cadr v)))))))))
      (cond ((number? e) e)
	    ((member e '($ + * ^ %)) e)
	    (else
	     (cdr (assq e a))))))

(write (numeval (read) '())) (newline)

#|
(display (numeval
 '(((^g(g g))(^g(^nr(? n 0 r((g g)(+ n -1)(* r n))))))5 1)
 '())) (newline)

(display (numeval
  '(((^g(g g))(^g(^nr(? n -1 r((g g) (+ n -1)($(((^g(g g))(^g(^nab(? n 0 a((g g)(+ n -1)b(+ a b))))))n 0 1)r))))))21 '())
  '())) (newline)

(display (numeval
  '(((^g(g g))(^g(^nr(? n 1 r(?(((^g (g g))(^g(^nx(? n x 1(? (% n x)0 -1((g g)n(+ x 1)))))))n 2)1((g g)(+ n -1)($ n r))((g g)(+ n -1)r))))))100 '())
 '())) (newline)
 
(display (numeval
  '(((^g(g g))(^g(^nr(? n 0 r(?(% n 15)0((g g)(+ n -1)($ 'FizzBuzz r))(?(% n 3)0((g g)(+ n -1)($ 'Fizz r))(?(% n 5)0((g g)(+ n -1)($ 'Buzz r))((g g)(+ n -1)($ n r)))))))))20 '())
 '())) (newline)

(display (numeval
  '(* 1(^(((^f((^g(g g))(^g(^unv(?(+ u 1)n(*(*(* 2(^ 2 0.5))(^(^ 99 2)-1))v)((g g)u(+ n 1)(+ v(*(*(+(* 26390 n)1103)(f(* 4 n)))(^(^(*(*(^ 4 n)(^ 99 n))(f n))4)-1)))))))))((^g(g g))(^g(^n(? n 0 1(* n((g g)(+ n -1))))))))2 0 0)-1))
  '())) (newline)
|#
