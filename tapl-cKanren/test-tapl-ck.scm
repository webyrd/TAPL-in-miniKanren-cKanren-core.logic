(load "cKanren/tester.scm")
(load "tapl-ck.scm")

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
