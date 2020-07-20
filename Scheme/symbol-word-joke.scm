#!/usr/bin/env gosh
; define lambda cond else if quote(')

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

