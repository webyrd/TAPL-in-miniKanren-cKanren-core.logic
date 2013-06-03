(load "cKanren/tester.scm")
(load "tapl.scm")

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
(test-check 'T-1
  (run* (q) (T 'true))
  '(_.0))

(test-check 'T-2
  (run* (q) (T 'false))
  '(_.0))

(test-check 'T-3
  (run* (q) (T 'zero))
  '(_.0))

(test-check 'T-4
  (run* (q) (T '(succ (succ (pred zero)))))
  '(_.0))

(test-check 'T-5
  (run* (q) (T '(succ (succ (pred false)))))
  '(_.0))

(test-check 'T-6
  (run* (q) (T '(succ (succ (pred foo)))))
  '())

(test-check 'T-7
  (run* (q) (T '(if false (succ zero) (pred (succ zero)))))
  '(_.0))

(test-check 'T-8
  (run* (q) (T ''(if false (succ foo) (pred (succ zero)))))
  '())

(test-check 'T-9
  (run 100 (q) (T q))
  '(true
    false
    zero
    (succ true)
    (succ false)
    (if true true true)
    (pred true)
    (succ zero)
    (if true true false)
    (iszero true)
    (if true true zero)
    (pred false)
    (if true false true)
    (iszero false)
    (pred zero)
    (if true false false)
    (iszero zero)
    (if false true true)
    (if true false zero)
    (if false true false)
    (succ (succ true))
    (if true true (succ true))
    (if true zero true)
    (if false true zero)
    (succ (succ false))
    (succ (if true true true))
    (if true true (succ false))
    (succ (pred true))
    (if true true (if true true true))
    (if true true (pred true))
    (succ (succ zero))
    (succ (if true true false))
    (if true true (succ zero))
    (if true zero false)
    (succ (iszero true))
    (if true true (if true true false))
    (if true true (iszero true))
    (pred (succ true))
    (succ (if true true zero))
    (iszero (succ true))
    (succ (pred false))
    (if true true (if true true zero))
    (if true false (succ true))
    (succ (if true false true))
    (if true true (pred false))
    (if true true (if true false true))
    (if true zero zero)
    (succ (iszero false))
    (if true true (iszero false))
    (pred (succ false))
    (iszero (succ false))
    (succ (pred zero))
    (pred (if true true true))
    (if true false (succ false))
    (succ (if true false false))
    (if true true (pred zero))
    (iszero (if true true true))
    (if true true (if true false false))
    (pred (pred true))
    (if true false (if true true true))
    (iszero (pred true))
    (succ (iszero zero))
    (if true false (pred true))
    (succ (if false true true))
    (if true true (iszero zero))
    (if true true (if false true true))
    (pred (succ zero))
    (iszero (succ zero))
    (if false false true)
    (pred (if true true false))
    (if true false (succ zero))
    (succ (if true false zero))
    (iszero (if true true false))
    (if true true (if true false zero))
    (pred (iszero true))
    (if true false (if true true false))
    (iszero (iszero true))
    (if true false (iszero true))
    (pred (if true true zero))
    (iszero (if true true zero))
    (if false true (succ true))
    (pred (pred false))
    (if true false (if true true zero))
    (iszero (pred false))
    (pred (if true false true))
    (if true false (pred false))
    (succ (if false true false))
    (iszero (if true false true))
    (succ (succ (succ true)))
    (if true true (if false true false))
    (if true false (if true false true))
    (if true true (succ (succ true)))
    (if false false false)
    (pred (iszero false))
    (succ (if true true (succ true)))
    (iszero (iszero false))
    (if true true (if true true (succ true)))
    (if true false (iszero false))
    (succ (if true zero true))
    (if true true (if true zero true))))

;; (test-check 'uniono-1
;;   (run* (q) (uniono '() '() q))
;;   '(()))

;; (test-check 'uniono-2
;;   (run* (q) (uniono '(a) '() q))
;;   '((a)))

;; (test-check 'uniono-3
;;   (run* (q) (uniono '() '(a) q))
;;   '((a)))

;; (test-check 'uniono-4
;;   (run* (q) (uniono '(a) '(b) q))
;;   '((a b)))

;; (test-check 'uniono-5
;;   (run* (q) (uniono '(a) '(b a) q))
;;   '((b a)))

;; (test-check 'uniono-6
;;   (run* (q) (uniono '(a) '(b a) q))
;;   '((b a)))

;; (test-check 'uniono-7
;;   (run* (q) (uniono '(a b) '(b a) q))
;;   '((b a)))

;; (test-check 'uniono-8
;;   (run* (q) (uniono '(a b) '(b a c) q))
;;   '((b a c)))

;; (test-check 'uniono-9
;;   (run* (q) (uniono '(a b d) '(b a c) q))
;;   '((d b a c)))

; 3.3.2  Term size  (p. 29)
(test-check 'size-1
  (run* (q) (sizeo 'true q))
  '(1))

(test-check 'size-2
  (run* (q) (sizeo 'false q))
  '(1))

(test-check 'size-3
  (run* (q) (sizeo 0 q))
  '(1))

(test-check 'size-4
  (run* (q) (sizeo '(pred 0) q))
  '(2))

(test-check 'size-5
  (run* (q) (sizeo '(succ (pred 0)) q))
  '(3))

(test-check 'size-6
  (run* (q) (sizeo '(if true 0 false) q))
  '(4))

(test-check 'size-7
  (run* (q) (sizeo '(if true (succ (pred 0)) (succ 0)) q))
  '(7))

(test-check 'size-8
  (run 50 (q) (fresh (t s) (sizeo t s) (== `(,t ,s) q)))
  '((true 1)
    (false 1)
    (0 1)
    ((succ true) 2)
    ((succ false) 2)
    ((succ 0) 2)
    ((pred true) 2)
    ((iszero true) 2)
    ((if true true true) 4)
    ((pred false) 2)
    ((if true true false) 4)
    ((iszero false) 2)
    ((if true true 0) 4)
    ((pred 0) 2)
    ((iszero 0) 2)
    ((if true false true) 4)
    ((if true false false) 4)
    ((if true false 0) 4)
    ((succ (succ true)) 3)
    ((if true 0 true) 4)
    ((if true true (succ true)) 5)
    ((succ (succ false)) 3)
    ((if true 0 false) 4)
    ((if true true (succ false)) 5)
    ((succ (succ 0)) 3)
    ((succ (pred true)) 3)
    ((if true 0 0) 4)
    ((if true true (succ 0)) 5)
    ((succ (iszero true)) 3)
    ((if true true (pred true)) 5)    
    ((succ (if true true true)) 5)
    ((pred (succ true)) 3)
    ((iszero (succ true)) 3)
    ((if true true (iszero true)) 5)
    ((succ (pred false)) 3)
    ((if true true (if true true true)) 7)
    ((succ (if true true false)) 5)
    ((succ (iszero false)) 3)
    ((if true false (succ true)) 5)
    ((if false true true) 4)
    ((if true true (pred false)) 5)
    ((if true true (if true true false)) 7)
    ((succ (if true true 0)) 5)
    ((pred (succ false)) 3)
    ((iszero (succ false)) 3)
    ((if true true (iszero false)) 5)
    ((succ (pred 0)) 3)
    ((if true true (if true true 0)) 7)
    ((succ (iszero 0)) 3)
    ((if true false (succ false)) 5)))

(test-check 'size-8
;;; alas, run 28 diverges  
  (run 27 (q) (sizeo q 3))
  '((succ (succ true))
    (succ (succ false))
    (succ (succ 0))
    (succ (pred true))
    (succ (iszero true))
    (pred (succ true))
    (iszero (succ true))
    (succ (pred false))
    (succ (iszero false))
    (pred (succ false))
    (iszero (succ false))
    (succ (pred 0))
    (succ (iszero 0))
    (pred (succ 0))
    (iszero (succ 0))
    (pred (pred true))
    (iszero (pred true))
    (pred (iszero true))
    (iszero (iszero true))
    (pred (pred false))
    (iszero (pred false))
    (pred (iszero false))
    (iszero (iszero false))
    (pred (pred 0))
    (iszero (pred 0))
    (pred (iszero 0))
    (iszero (iszero 0))))
