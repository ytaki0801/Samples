; TITLE: Schemeの継続（call/cc）のサンプル


; #継続渡しとcall/cc

; まず，複数の手続き/, *, -が次々と呼び出される例を考える．
(display (/ (* (- 100 58) 2) 4))    ; =>  21

; ここで，-を，引き算した結果を掛け算*に直接渡すのではなく，
; 引き算した結果を指定する手続き(cf)に渡す，-cfに書き換える．
(define -cf (lambda (a b cf) (cf (- a b))))

; 指定する手続きとして，*だけでなく/を含めた残りの計算を行う手続き
; cfuncを定義する．
(define cfunc (lambda (x) (/ (* x 2) 4)))

; -cfとcfuncを用いて，(/ (* (- 100 58) 2) 4)と同じ計算を行ってみる．
(display (-cf 100 58 cfunc))    ; => 21
 
; 処理した結果を他の関数に直接渡すのではなく，渡す関数を指定する方法を，
;（cfuncに継続させるという意味で，値渡しではなく）継続渡しという．

; call-with-current-continuationは，継続渡しの手続きを作り出してくれる．
(display (/ (* (call-with-current-continuation (lambda (cfunc) (- 100 58))) 2) 4))    ; => 21

; 上記の例で作り出されたcfuncは(lambda (x) (/ (* x 2) 4)であり，
; defineとset!を用いて，外部(exfunc)に保管して再利用することができる．
(define exfunc)
(display (/ (* (call-with-current-continuation (lambda (cfunc) (set! exfunc cfunc) (- 100 58))) 2) 4))    ; => 21
(display (exfunc 20))    ; => 10

; 手続きの冒頭にcall-with-current-continuationを設定すると，
; 『何も残っていない』継続渡しの手続きが作り出される．
(define exfunc)
(display (call-with-current-continuation (lambda (cfunc) (set! exfunc cfunc) (/ (* (- 100 58) 2) 4))))    ; => 21
(display (exfunc 20))    ; => 20

; なお，call-with-current-continuationは長いので，call/ccと省略されることが多い．
(define exfunc)
(display (/ (* (call/cc (lambda (cfunc) (set! exfunc cfunc) (- 100 58))) 2) 4))    ; => 21
(display (exfunc 20))    ; => 10


; #継続（call/cc）の利用例

; ##大域脱出
; 手続き定義のlambdaの直後にcall/ccを設定することで，不具合が出た時などに，
; 『何も残っていない』継続処理を行わせることで，処理全体を終了できる．

; 不具合が出た時などに処理を終了したい場合は，通常，不具合か否かを判断し，
; 不具合であれば本来の処理を行わずに終了する．ただし，再帰処理の場合は，
; 正常終了の場合も不具合の場合も，呼び出し元に戻る処理が繰り返される．

(define 100div-list
  (lambda (L)
    (let loop ((L L))
      (cond ((null? L) "No Error")
            (else
             (cond ((= (car L) 0) "Zero Error")
                   (else
                    (display (format "100.0/~w=~w" (car L) (/. 100.0 (car L))))
                    (newline)
                    (loop (cdr L))
                    (display "Return Check") (newline))))))))
(100div-list '(5 1 3 8 4 2))
; => 100.0/5=20.0
;    100.0/1=100.0
;    100.0/3=33.333333333333336
;    100.0/8=12.5
;    100.0/4=25.0
;    100.0/2=50.0
;    Return Check
;    Return Check
;    Return Check
;    Return Check
;    Return Check
;    Return Check
(100div-list '(5 1 3 0 4 2))
; => 100.0/5=20.0
;    100.0/1=100.0
;    100.0/3=33.333333333333336
;    Return Check
;    Return Check
;    Return Check

; 正常終了や不具合の場合に繰り返し呼び出し元に戻る必要がない場合は，
; 手続き冒頭のcall/ccによる『何も残っていない』継続処理を用いることで，
; 呼び出し元に繰り返し戻ることなく終了させることができる．

(define 100div-list
  (lambda (L)
    (call/cc
      (lambda (jmp)
        (let loop ((L L))
          (cond ((null? L) (jmp "No Error"))
                (else
                 (cond ((= (car L) 0) (jmp "Zero Error")))
                 (display (format "100.0/~w=~w" (car L) (/. 100.0 (car L))))
                 (newline)
                 (loop (cdr L))
                 (display "Return Check") (newline))))))))
(100div-list '(5 1 3 8 4 2))
; => 100.0/5=20.0
;    100.0/1=100.0
;    100.0/3=33.333333333333336
;    100.0/8=12.5
;    100.0/4=25.0
;    100.0/2=50.0
(100div-list '(5 1 3 0 4 2))
; => 100.0/5=20.0
;    100.0/1=100.0
;    100.0/3=33.333333333333336

