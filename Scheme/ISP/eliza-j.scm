;;;;
;;;; eliza-j.scm
;;;;
;;;; 擬似対話プログラムELIZA(日本語改)
;;;;

;;;; ＜サンプル対話＞
;;;; (interview)
;;;; あなたがこの学校を受験した理由はなんですか？
;;;; :-) スポーツマンになりたいからです。
;;;; この学校でどんなスポーツをしたいですか？
;;;; :-) テニスをしたいです。
;;;; あなたはウィンブルドンを知っていますか？
;;;; :-) はい。
;;;; この試験を受けることを薦めたのは誰ですか？
;;;; :-) 父です。
;;;; あなたのお父さんはこの学校に通うことを賛成していますか？
;;;; :-) はい。
;;;; わかりました。
;;;; :-) さようなら。
;;;; さようなら。

;;;; kakasi による分かち書き
(use text.kakasi)

;;;; 面接試験用スクリプトデータベース
(define *r1*
  '(1 (この学校でどんなスポーツをしたいですか？)
      (この試験を受けることを薦めたのは誰ですか？)
      (わかりました。)))
(define *r2*
  '(1 (それをあなたに示したのはなんですか？)
      (なぜそう思いますか？)
      (あなたは自分がどのような人間だと思いますか？)
      (わかりました。)))
(define *r3*
  '(1 (あなたはウィンブルドンを知っていますか？)
      (テニスは好きですか？)
      (他のスポーツはしますか？)
      (わかりました。)))
(define *r4*
  '(1 (コンピュータは使えますか？)
      (コンピュータを使い始めたのはいつですか？)
      (わかりました。)))
(define *r5*
  '(1 (どんなことに興味がありますか？)
      (わかりました。)))
(define *r6*
  '(1 (あなたのお父さんはこの学校に通うことを賛成していますか？)
      (あなたの先生はこの学校に通うことを賛成していますか？)
      (わかりました。)))

;;;; 優先順位
(define *resp* (list *r1* *r2* *r3* *r4* *r5* *r6*))

;;;; キーワードリスト
(define *dic*
  '((なりたい key 2) (テニス key 3) (コンピュータ key 4) (興味 key 5)
    (父 key 6) (先生 key 6)))

;;;; メインプログラム
(define interview
  (lambda ()
    (display "あなたがこの学校を受験した理由はなんですか？")
    (newline)
    (do ((key '()) (msg (read-sentence) (read-sentence)) (old '() msg))
        ((member (car msg) '(さようなら))
         (display "さようなら。")
         (newline))
      (cond ((equal? msg old)
             (display "同じ回答を繰り返さないでください。"))
            (else (set! key (keysearch msg))
                  (for-each display (reply (car key)))))
      (newline))))

;;;; 文章の読み込み(句点には『。』を用いる)
;;;; 私はこの学校が好きです。 ==> (私 はこの 学校 が 好き です)
(define read-sentence
  (lambda ()
    (display ":-) ")
    (flush)
    (let loop ((words (get-wakati)) (sentence '()))
      (if (equal? (car (reverse words)) '。)
          (let ((last (reverse (cdr (reverse words)))))
            (append sentence last))
          (loop (get-wakati) (append sentence words))))))

;;;; 一行読み込み，単語リストにして返す
;;;; 今日は良い天気 ==> (今日は 良い 天気)
(define get-wakati
  (lambda ()
    (map string->symbol (kakasi-wakati (symbol->string (read))))))

;;;; 辞書参照関数
;;;; (getdic 'なりたい 'key) ==> 2
(define getdic
  (lambda (foo baz)
    (do ((jisyo *dic* jisyo))
        ((or (null? jisyo)
             (and (equal? foo (caar jisyo))
                  (equal? baz (cadar jisyo))))
         (if (null? jisyo) jisyo (list-ref (car jisyo) 2)))
      (set! jisyo (cdr jisyo)))))

;;;; キーワード検索関数
;;;; (keysearch '(私 は コンピュータ に 興味 があります))
;;;; ==> (4 に 興味 があります)
(define keysearch
  (lambda (msg)
    (do ((keynum 1 keynum) (thiskey 1 thiskey) (left '() left) (word '() word))
        ((null? msg) (cons keynum left))
      (set! word (car msg))
      (if (number? word)
          (set! thiskey 1)
          (set! thiskey (getdic word 'key)))
      (cond ((not (number? thiskey))
             '()
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

;;;; 回答文章作成関数
;;;; (reply 3) ==> (あなたはウィンブルドンを知っていますか？)
(define reply
  (lambda (keynum)
    (let* ((res (list-ref *resp* (- keynum 1)))
           (out (list-ref (cdr res) (- (car res) 1))))
      (cond ((null? out)
             (set-car! res 2)
             (set! out (cadr res)))
            (else
             (set-car! res (+ (car res) 1))))
      out)))
