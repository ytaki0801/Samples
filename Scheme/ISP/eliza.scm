;;;;
;;;; eliza.scm
;;;;
;;;; 擬似対話プログラムELIZA
;;;;

;;;; 面接試験用スクリプトデータベース
(define *r1* 
  '(1 (What sports will you play in this school ?)
      (Who encouraged you to take this examination ?)
      (I see ..)))
(define *r2* 
  '(1 (* Why do you want)
      (* Do you like)
      (I see ..)))
(define *r3* 
  '(1 (* Why do you like)
      (Why do you think so ?)
      (I see ..)))
(define *r4* 
  '(1 (What does that suggest to you ?) 
      (Why do you think so ?)
      (What kind of person do you think you are ?)
      (I see ..)))
(define *r5* 
  '(1 (Do you know of Winbldon ?)
      (Do you like tennis ?)
      (Do you play other sports ?)
      (I see ..)))
(define *r6* 
  '(1 (Can you use computers ?) 
      (When do you begin to use computers ?)
      (I see ..)))
(define *r7* 
  '(1 (What are you interested in ?)
      (I see ..)))
(define *r8* 
  '(1 (Does your father approve of your going to this school ?)
      (Also does your teacher approve of your going to this school ?) 
      (I see ..)))

;;;; 優先順位
(define *resp* (list *r1* *r2* *r3* *r4* *r5* *r6* *r7* *r8*))

;;;; キーワードリスト
(define *dic* 
  '((I conj you) (You conj me) (me conj you) (my conj your) (your conj my)
    (am conj are)
    (I key want) (I key like) (I want 2) (I like 3) (I key2 4)
    (tennis key 5) (computers key 6) (computer key 6) (interest key 7)
    (interesting key 7) (interested key 7) (father key 8)))

;;;; メインプログラム
(define interview
  (lambda ()
    (display "Why do you take the examination of this school ?")
    (newline)
    (do ((key '()) (msg (read-sentence) (read-sentence)) (old '() msg))
        ((member (car msg) '(goodbye bye exit quit end))
         (display "Goodbye ..")
         (newline))
      (cond ((equal? msg old)
             (display " Please do not repeat yourself .."))
            (else (set! key (keysearch msg))
             (print-list (reply (word-conjugate (cdr key)) (car key)))))
      (newline))))

;;;; 文章の読み込み(句点には .. を用いる)
;;;; I like this school .. ==> (I like this school)
(define read-sentence
  (lambda ()
    (display ":-) ")
    (flush)
    (let loop ((token (read)) (sentence '()))
      (if (equal? token '..)
          sentence
          (loop (read) (append sentence (list token)))))))

;;;; 辞書参照関数
;;;; (getdic 'I 'want) ==> 2
(define getdic
  (lambda (foo baz)
    (do ((jisyo *dic* jisyo))
        ((or (null? jisyo)
             (and (equal? foo (caar jisyo))
                  (equal? baz (cadar jisyo))))
         (if (null? jisyo) jisyo (list-ref (car jisyo) 2)))
      (set! jisyo (cdr jisyo)))))

;;;; キーワード検索関数
;;;; (keysearch '(I like this school)) ==> (3 this school)
(define keysearch
  (lambda (msg)
    (do ((keynum 1 keynum) (thiskey 1 thiskey) (left '() left) (word '() word))
        ((null? msg) (cons keynum left))
      (set! word (car msg))
      (if (number? word)
          (set! thiskey 1)
          (set! thiskey (getdic word 'key)))
      (cond ((not (number? thiskey))
             (set! thiskey (keyphrase word (cdr msg) thiskey))
             (cond ((null? thiskey)
                    (set! msg (cdr msg))
                    (let ((z (getdic word 'key2)))
                      (if (null? z)
                          (set! thiskey 1)
                          (set! thiskey z))))
                   (else
                    (set! msg (cdr thiskey))
                    (set! thiskey (car thiskey)))))
            (else (set! msg (cdr msg))))
      (cond ((> thiskey keynum)
             (set! keynum thiskey)
             (set! left msg))))))

;;;; 熟語検索関数
;;;; (keyphrase 'I '(want to computers) '(want)) ==> (2 to computers)
(define keyphrase
  (lambda (word msg thiskey)
    (do ((return '()))
        ((null? thiskey) return)
      (cond ((number? thiskey)
             (set! return (cons thiskey msg))
             (set! thiskey '()))
            (else (set! thiskey (getdic word (car msg)))
                  (set!  msg (cdr msg)))))))

;;;; 縁語置換関数
;;;; (word-conjugate '(I like)) ==> (you like)
(define word-conjugate
  (lambda (oldt)
    (do ((new '() new) (w '() w) (w2 '() w2))
        ((null? oldt ) new)
      (set! w (car oldt))
      (cond ((number? w)
             (set! w2 '())
             (set!  w (list w)))
            (else
             (set! w2 (getdic w 'conj))
             (set! w (list w))))
      (if (null? w2)
          (set! new (append new w))
          (set! new (append new (list w2))))
      (set!  oldt (cdr oldt)))))

;;;; 回答文章作成関数
;;;; (reply '(me) 3) ==> (Why do you like me ?)
(define reply
  (lambda (new keynum)
    (let* ((res (list-ref *resp* (- keynum 1)))
           (new (append new '(?)))
           (out (list-ref (cdr res) (- (car res) 1))))
      (cond ((null? out)
             (set-car! res 2)
             (set! out (cadr res)))
            (else
             (set-car! res (+ (car res) 1))))
      (if (equal? (car out) '*)
          (set! out (append (cdr out) new)))
      out)))

;;;; 回答文章出力関数
;;;; (print-list '(I see)) ==> I see
(define print-list
  (lambda (lst)
    (cond ((not (null? lst))
           (display (car lst))
           (if (not (null? (cdr lst))) (display " "))
           (print-list (cdr lst))))))
