; define lambda cond else if quote(')
; quasiquote(`) unquote(,) unquote-splicing(,@)

(define div /)
(define / define)
(/ $ lambda)
(/ ?? cond)
(/ ?+ else)
(/ ? if)
(/ mul *)
(/ gt >)
(/ lt <)

(/ a 10)
(/ cube ($ (x) (mul x x x)))
(display (?? ((gt (cube a) 100) 'one) (?+ 'two)))
(display (? (lt (cube a) 100) 'one 'two))

