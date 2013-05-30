#lang cKanren

;;; Dependencies:  Racket and cKanren (https://github.com/calvis/cKanren)
(require cKanren/miniKanren)
(require cKanren/sets)

; 3.2.3  Terms, concretely (p. 27)
; Defined using CLP(Set) and Peano numbers (z, (s z), (s (s z)), etc.)
(define So
  (lambda (i Si)
    (conde
      [(== 'z i) (== (empty-set) Si)]
      [(== '(s z) i)
       (fresh (Sa Sb)
         (uniono (empty-set) (make-set '(true false 0)) Sa)
         (uniono Sa (make-set '(succ pred iszero)) Sb)
         (uniono Sb (make-set '(if)) Si))]
      [(fresh (i-1 i-2 Si-1 t1 t2 t3 Sa Sb)
         (== `(s ,i-1) i)
         (== `(s ,i-2) i-1)
         (So i-1 Si-1)
         (ino t1 Si-1)
         (ino t2 Si-1)
         (ino t3 Si-1)
         (uniono (empty-set) (make-set '(true false 0)) Sa)
         (uniono Sa (make-set `((succ ,t1) (pred ,t1) (iszero ,t1))) Sb)
         (uniono Sb (make-set `((if ,t1, t2 ,t3))) Si))])))

;;; I'm a Racket nub, and don't know how to properly turn these runs into tests
(run* (q) (So 'z q))
(run* (q) (So '(s z) q))
(run* (q) (So '(s (s z)) q))
(run* (q) (So '(s (s (s z))) q))
