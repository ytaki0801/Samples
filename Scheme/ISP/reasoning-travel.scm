;;;;
;;;; reasoning-travel.scm
;;;;
;;;; 旅行先案内
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
     (set! *working-memory*
   (eval-action (car (cdr (cdr (cdr rule))))))
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

;;;; 旅行先案内：ルールベースの定義
(define *rule-base*
  '((rule1 (and (アメリカ) (英語)) --> (ホノルル))
    (rule2 (and (ヨーロッパ) (フランス)) --> (パリ))
    (rule3 (and (アメリカ) (大陸)) --> (ロサンゼルス))
    (rule4 (and (島) (赤道)) --> (ホノルル))
    (rule5 (and (アジア) (赤道)) --> (シンガポール))
    (rule6 (and (島) (ミクロネシア)) --> (グアム))
    (rule7 (水泳) --> (赤道))))

;;;; 旅行先案内：ワーキングメモリの定義
(define *working-memory* '((島) (水泳)))
;(define *working-memory* '((アジア) (水泳)))

;;;; 旅行先案内：結論が導かれた時の処理
(define eval-action
  (lambda (action)
    (set! *working-memory* (cons action *working-memory*))))
