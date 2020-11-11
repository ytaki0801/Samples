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

(define (setf-plist! symbol key data)
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

; for GNU Guile
(defmacro setf! (gets val)
  `(setf-plist! ,(cadr gets) ,(caddr gets) ,val))

;;;; sample codes at http://www.nct9.ne.jp/m_hiroi/clisp/abcl12.html
(display (setf! (get 'taro 'height) 180)) (newline)
(display (setf! (get 'taro 'weight) 80)) (newline)
(display (symbol-plist 'taro)) (newline)
(display (get 'taro 'height)) (newline)
(display (get 'taro 'weight)) (newline)
(display (get 'taro 'bust)) (newline)
(display (remprop! 'taro 'height)) (newline)
(display (get 'taro 'height)) (newline)
(display (symbol-plist 'taro)) (newline)

