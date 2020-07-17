;;;;
;;;; reasoning-blocks.scm
;;;;
;;;; 積木の世界
;;;;

(define reasoning
  (lambda ()
    (let loop ((rule (choice (pattern-matching))))
      (cond ((not (or (null? rule) (equal? rule 'quit)))
             (rule-action! rule)
             (loop (choice (pattern-matching))))))))

;;;; ルールベースとワーキングメモリの照合を行い，選択可能なルールを導出
(define pattern-matching
  (lambda ()
    (let loop ((enables '()) (rules *rule-base*))
      (cond ((null? rules) enables)
            ((rule-cond? (car (cdr (car rules))))
             (loop (cons (car (car rules)) enables) (cdr rules)))
            (else
             (loop enables (cdr rules)))))))

;;;; ルールベースの条件部がワーキングメモリに含まれるかチェック
(define rule-cond?
  (lambda (condition)
    (cond ((null? condition) #t)
          ((equal? (car condition) 'and)
           (condition-aux? (cdr condition))) ;; and 表現ならば各条件をチェック
          (else
           (member condition *working-memory*)))))

(define condition-aux?
  (lambda (condition)
    (cond ((null? condition) #t)
          ((member (car condition) *working-memory*)
           (condition-aux? (cdr condition)))
          (else #f))))

(define choice
  (lambda (rules)
    (cond ((null? rules) '())
          (else
           (display "選択可能なルール：")
           (display rules)
           (newline)
           (display "ルールの選択 >> ")
           (flush)
           (read)))))

(define rule-action!
  (lambda (rule)
    (let ((rule (get-rule rule)))
      (cond ((not (null? rule))
             (eval-action (car (cdr (cdr (cdr rule)))))
             (display "*working-memory*：")
             (display *working-memory*)
             (newline))))))

(define get-rule
  (lambda (rule)
    (let loop ((rules *rule-base*))
      (if (null? rules)
          '()
          (let ((r1 (car rules)))
            (if (equal? (car r1) rule)
                r1
                (loop (cdr rules))))))))

;;;; 積木の世界：ルールベースの定義
(define *rule-base*
  '((rule1 (clear a) --> (on a table))
    (rule2 (clear b) --> (on b table))
    (rule3 (clear c) --> (on c table))
    (rule4 (and (clear a) (clear b)) --> (on a b))
    (rule5 (and (clear a) (clear c)) --> (on a c))
    (rule6 (and (clear b) (clear a)) --> (on b a))
    (rule7 (and (clear b) (clear c)) --> (on b c))
    (rule8 (and (clear c) (clear a)) --> (on c a))
    (rule9 (and (clear c) (clear b)) --> (on c b))))

;;;; 積木の世界：ワーキングメモリの定義
(define *working-memory*
  '((on a table) (clear b) (on b table) (on c a) (clear c)))

;;;; 積木の世界：結論が導かれた時の処理
(define eval-action
  (lambda (on-rule)
    (if (equal? (car on-rule) 'on)
        (on (car (cdr on-rule)) (car (cdr (cdr on-rule))))
        (else '()))))
(define on
  (lambda (x y)
    (set! *working-memory* (remove-clear y))
    (set! *working-memory* (insert-clear x))
    (set! *working-memory* (cons (list 'on x y) *working-memory*))))

(define remove-clear
  (lambda (n)
    (let loop ((mems *working-memory*))
      (if (null? mems)
          '()
          (let* ((item (car mems)))
            (if (and (equal? (car item) 'clear)
                     (equal? (car (cdr item)) n))
                (loop (cdr mems))
                (cons item (loop (cdr mems)))))))))

(define insert-clear
  (lambda (n)
    (let loop ((mems *working-memory*))
      (if (null? mems)
          '()
          (let* ((item (car mems)))
            (if (and (equal? (car item) 'on)
                     (equal? (car (cdr item)) n))
                (if (equal? (car (cdr (cdr item))) 'table)
                    (loop (cdr mems))
                    (cons (list 'clear (car (cdr (cdr item))))
                          (loop (cdr mems))))
                (cons item (loop (cdr mems)))))))))
