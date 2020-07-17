;;;;
;;;; let-do.scm
;;;;
;;;; letによる反復表現とdoによる対応表現の例
;;;;

(let loop ((i 0))
  (cond ((>= i 10) (newline))
	(else
	 (display i)
	 (loop (+ i 1)))))

(do ((i 0 (+ i 1)))
    ((>= i 10) (newline))
  (display i))

; for (i = 0; i < 10; i++) {
;   printf("%d", i);
; }
; printf("\n");
