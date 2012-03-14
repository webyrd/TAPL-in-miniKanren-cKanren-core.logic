(load "cKanren/tester.scm")
(load "tapl-ck.scm")

; 3.2.1  Terms, inductively  (p. 26)  
(test-check 'T?-1
  (T? 'true)
  #t)

(test-check 'T?-2
  (T? 'false)
  #t)

(test-check 'T?-3
  (T? 'zero)
  #t)

(test-check 'T?-4
  (T? '(succ (succ (pred zero))))
  #t)

(test-check 'T?-5
  (T? '(succ (succ (pred false))))
  #t)

(test-check 'T?-6
  (T? '(succ (succ (pred foo))))
  #f)

(test-check 'T?-7
  (T? '(if false (succ zero) (pred (succ zero))))
  #t)

(test-check 'T?-8
  (T? '(if false (succ foo) (pred (succ zero))))
  #f)


; 3.2.2  Terms, by inference rules (p. 26)

;;  need to fix the names for the cKanren submodule

;; (test-check 'T-1
;;   (run* (q) (T 'true))
;;   '(_.0))

;; (test-check 'T-2
;;   (run* (q) (T 'false))
;;   '(_.0))

;; (test-check 'T-3
;;   (run* (q) (T 'zero))
;;   '(_.0))

;; (test-check 'T-4
;;   (run* (q) (T '(succ (succ (pred zero)))))
;;   '(_.0))

;; (test-check 'T-5
;;   (run* (q) (T '(succ (succ (pred false)))))
;;   '(_.0))

;; (test-check 'T-6
;;   (run* (q) (T '(succ (succ (pred foo)))))
;;   '())

;; (test-check 'T-7
;;   (run* (q) (T '(if false (succ zero) (pred (succ zero)))))
;;   '(_.0))

;; (test-check 'T-8
;;   (run* (q) (T ''(if false (succ foo) (pred (succ zero)))))
;;   '())

;; (test-check 'T-9
;;   (run 100 (q) (T q))
;;   '(true
;;     false
;;     zero
;;     (succ true)
;;     (succ false)
;;     (if true true true)
;;     (pred true)
;;     (succ zero)
;;     (if true true false)
;;     (iszero true)
;;     (if true true zero)
;;     (pred false)
;;     (if true false true)
;;     (iszero false)
;;     (pred zero)
;;     (if true false false)
;;     (iszero zero)
;;     (if false true true)
;;     (if true false zero)
;;     (succ (succ true))
;;     (if true true (succ true))
;;     (if false true false)
;;     (if true zero true)
;;     (succ (succ false))
;;     (succ (if true true true))
;;     (if true true (succ false))
;;     (if false true zero)
;;     (succ (pred true))
;;     (if true true (if true true true))
;;     (if true true (pred true))
;;     (succ (succ zero))
;;     (succ (if true true false))
;;     (if true true (succ zero))
;;     (succ (iszero true))
;;     (if true true (if true true false))
;;     (pred (succ true))
;;     (if true true (iszero true))
;;     (iszero (succ true))
;;     (if true zero false)
;;     (if true false (succ true))
;;     (succ (if true true zero))
;;     (succ (pred false))
;;     (if true true (if true true zero))
;;     (succ (if true false true))
;;     (if true true (pred false))
;;     (if true true (if true false true))
;;     (succ (iszero false))
;;     (pred (succ false))
;;     (if true true (iszero false))
;;     (iszero (succ false))
;;     (if true zero zero)
;;     (pred (if true true true))
;;     (if true false (succ false))
;;     (iszero (if true true true))
;;     (succ (pred zero))
;;     (pred (pred true))
;;     (if true false (if true true true))
;;     (succ (if true false false))
;;     (if true true (pred zero))
;;     (iszero (pred true))
;;     (if true true (if true false false))
;;     (if true false (pred true))
;;     (succ (iszero zero))
;;     (pred (succ zero))
;;     (succ (if false true true))
;;     (if true true (iszero zero))
;;     (iszero (succ zero))
;;     (if true true (if false true true))
;;     (pred (if true true false))
;;     (if true false (succ zero))
;;     (iszero (if true true false))
;;     (pred (iszero true))
;;     (if true false (if true true false))
;;     (succ (if true false zero))
;;     (iszero (iszero true))
;;     (if false false true)
;;     (if true true (if true false zero))
;;     (if true false (iszero true))
;;     (if false true (succ true))
;;     (succ (succ (succ true)))
;;     (pred (if true true zero))
;;     (if true true (succ (succ true)))
;;     (iszero (if true true zero))
;;     (pred (pred false))
;;     (if true false (if true true zero))
;;     (iszero (pred false))
;;     (pred (if true false true))
;;     (if true false (pred false))
;;     (succ (if true true (succ true)))
;;     (iszero (if true false true))
;;     (if true true (if true true (succ true)))
;;     (if true false (if true false true))
;;     (succ (if false true false))
;;     (if true true (if false true false))
;;     (pred (iszero false))
;;     (iszero (iszero false))
;;     (if false false false)
;;     (if true false (iszero false))
;;     (if false true (succ false))
;;     (succ (if true zero true))))
