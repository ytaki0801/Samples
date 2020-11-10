;;;;
;;;; Pattern Matching example
;;;; ported from Section 5.2 at https://github.com/norvig/paip-lisp
;;;;

(define (variable? x)
  (and (symbol? x)
       (equal? (string-ref (symbol->string x) 0) #\?)))

(define (sublis al L)
  (if (null? L) '()
      (cons (let ((r (assq (car L) al)))
              (if r (cdr r) (car L)))
            (sublis al (cdr L)))))

(define fail #f)

(define no-bindings '((#t . #t)))

(define (get-binding var bindings) (assq var bindings))

(define (binding-val binding) (cdr binding))

(define (extend-bindings var val bindings)
  (cons (cons var val)
        (if (equal? bindings no-bindings) '() bindings)))

(define (match-variable var input bindings)
  (let ((binding (get-binding var bindings)))
    (cond ((not binding) (extend-bindings var input bindings))
          ((equal? input (binding-val binding)) bindings)
          (else fail))))

(define (pat-match pattern input . r)
  (let ((bindings (if (null? r) no-bindings (car r))))
    (cond ((eq? bindings fail) fail)
          ((variable? pattern)
           (match-variable pattern input bindings))
          ((equal? pattern input) bindings)
          ((and (pair? pattern) (pair? input))
           (pat-match (cdr pattern) (cdr input)
                      (pat-match (car pattern) (car input)
                                 bindings)))
          (else fail))))

