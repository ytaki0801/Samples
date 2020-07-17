(define (ch x)
  (define (p? n) (zero? (modulo x n)))
  (cond ((p? 15) 'FizzBuzz) ((p? 3) 'Fizz) ((p? 5) 'Buzz) (else x)))
(display (map ch (cdr (iota 101))))

