#!/usr/bin/env gosh
; define lambda cond else if quote(')

(define d /)
(define / define)
(/ \ lambda)
(/ ?? cond)
(/ ?+ else)
(/ ? if)
(/ m *)
(/ g >)
(/ l <)

(/ a 10)
(/ c (\ (x) (m x x x)))
(display (?? ((g (c a) 100) 'one)
             (?+ 'two)))
(display (? (l (c a) 100) 'one 'two))

