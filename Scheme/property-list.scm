;;;;
;;;; pseudo-property list operations
;;;;

(define *plist* '())

(define (symbol-plist symbol)
  (let ((r (assq symbol *plist*)))
    (if r (cdr r) r)))

(define (get symbol key)
  (let ((r (symbol-plist symbol)))
    (if r
	(let ((v (member key r))) (if v (cadr v) v))
	r)))

(define (delete-plist symbol pl)
  (cond ((null? pl) '())
	((eq? symbol (caar pl)) (cdr pl))
	(else (cons (car pl)
		    (delete-plist symbol (cdr pl))))))

(define (putprop! symbol data key)
  (let ((r (assq symbol *plist*)))
    (set! *plist*
      (if (not r)
	  (cons (cons symbol (list key data)) *plist*)
	  (cons
	    (cons symbol (append (list key data) (cdr r)))
	    (delete-plist symbol *plist*)))))
  data)

(define (delete-prop key prop)
  (cond ((null? prop) '())
	((eq? key (car prop)) (cddr prop))
	(else (append (list (car prop) (cadr prop))
		      (delete-prop key (cddr prop))))))

(define (remprop! symbol key)
  (let ((r (assq symbol *plist*)))
    (if (not r)
        #f
	(begin
	  (let ((r1 (list key (get symbol key))))
  	    (set! *plist*
	      (cons (cons symbol (delete-prop key (cdr r)))
		    (delete-plist symbol *plist*)))
	    r1)))))

;;;; sample at http://www.nct9.ne.jp/m_hiroi/clisp/abcl12.html
(display (putprop! 'taro 180 'height)) (newline)
(display (putprop! 'taro 80 'weight)) (newline)
(display (symbol-plist 'taro)) (newline)
(display (get 'taro 'height)) (newline)
(display (get 'taro 'weight)) (newline)
(display (get 'taro 'bust)) (newline)
(display (remprop! 'taro 'height)) (newline)
(display (get 'taro 'height)) (newline)
(display (symbol-plist 'taro)) (newline)

;;;; sample at http://www.et.hum.titech.ac.jp/~matsuda/lisp/5kai/5-2.html
(display (putprop! 'matsuda 'male 'sex)) (newline)
(display (get 'matsuda 'sex)) (newline)
(display (putprop! 'matsuda 167 'height)) (newline)
(display (symbol-plist 'matsuda)) (newline)
(display (remprop! 'matsuda 'height)) (newline)
(display (symbol-plist 'matsuda)) (newline)

