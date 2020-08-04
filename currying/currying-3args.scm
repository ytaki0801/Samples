(define (func x y z) (* (- x y) (- x z)))
(print (func 10 2 3))        ; => 56

(define func (lambda (x) (lambda (y) (lambda (z)
  (* (- x y) (- x z))))))
(print (((func 10) 2) 3))    ; => 56

; x = 10, y = 2, z = 0 1 2 3 4
(define fxy ((func 10) 2))
(define fxyz (map fxy (iota 5)))
(print fxyz)    ; => (80 72 64 56 48)

; x = 10, y = 0 1 2 3 4, z = 3
(define fx (func 10))
(define fxy (map fx (iota 5)))
(define fxyz (map (lambda (f) (f 3)) fxy))
(print fxyz)    ; => (70 63 56 49 42)

; x = 0 1 2 3 4, y = 2, z = 3
(define fx (map func (iota 5)))
(define fxyz (map (lambda (f) ((f 2) 3)) fx))
(print fxyz)    ; => (6 2 0 0 2)
