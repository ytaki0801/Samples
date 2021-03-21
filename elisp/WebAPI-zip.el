(require 'request)
(require 'json)
(require 'cl-lib)

(defun zipjp (n)
  (request
   "https://zipcloud.ibsnet.co.jp/api/search"
   :params (list (cons "zipcode" n))
   :parser 'json-read
   :success
   (cl-function
    (lambda (&key data &allow-other-keys)
      (let* ((r (elt (assoc-default 'results data) 0))
	     (a1 (assoc-default 'address1 r))
	     (a2 (assoc-default 'address2 r))
	     (a3 (assoc-default 'address3 r)))
	(insert "; => " a1 a2 a3 "\n")))))
  t)

(zipjp 3100011)
; => 茨城県水戸市三の丸
(zipjp 3870011)
; => 長野県千曲市杭瀬下
