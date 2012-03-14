;; Translation of Benjamin C. Pierce's 'Types and Programming
;; Languages' into miniKanren/cKanren/core.logic

;; William E. Byrd
;; webyrd@gmail.com

(load "match.ss")
(load "mK/mkdefs.scm")

; 3.2.1  Terms, inductively  (p. 26)

; plain Scheme for this one!
(define T?
  (lambda (t)
    (match t
      [true #t]
      [false #t]
      [zero #t]
      [(succ ,[t1]) #t]
      [(pred ,[t1]) #t]
      [(if ,[t1] ,[t2] ,[t3]) #t]
      [else #f])))

; 3.2.2  Terms, by inference rules (p. 26)

; I'm using the symbol 'zero' to represent 0
(define T
  (lambda (t)
    (conde
      [(== 'true t)]
      [(== 'false t)]
      [(== 'zero t)]
      [(fresh (t1)
         (conde
           [(== `(succ ,t1) t)]
           [(== `(pred ,t1) t)]
           [(== `(iszero ,t1) t)])
         (T t1))]
      [(fresh (t1 t2 t3)
         (== `(if ,t1 ,t2 ,t3) t)
         (T t1)
         (T t2)
         (T t3))])))

(run 100 (q) (T q))
=>
(true
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
 (succ (succ true))
 (if true true (succ true))
 (if false true false)
 (if true zero true)
 (succ (succ false))
 (succ (if true true true))
 (if true true (succ false))
 (if false true zero)
 (succ (pred true))
 (if true true (if true true true))
 (if true true (pred true))
 (succ (succ zero))
 (succ (if true true false))
 (if true true (succ zero))
 (succ (iszero true))
 (if true true (if true true false))
 (pred (succ true))
 (if true true (iszero true))
 (iszero (succ true))
 (if true zero false)
 (if true false (succ true))
 (succ (if true true zero))
 (succ (pred false))
 (if true true (if true true zero))
 (succ (if true false true))
 (if true true (pred false))
 (if true true (if true false true))
 (succ (iszero false))
 (pred (succ false))
 (if true true (iszero false))
 (iszero (succ false))
 (if true zero zero)
 (pred (if true true true))
 (if true false (succ false))
 (iszero (if true true true))
 (succ (pred zero))
 (pred (pred true))
 (if true false (if true true true))
 (succ (if true false false))
 (if true true (pred zero))
 (iszero (pred true))
 (if true true (if true false false))
 (if true false (pred true))
 (succ (iszero zero))
 (pred (succ zero))
 (succ (if false true true))
 (if true true (iszero zero))
 (iszero (succ zero))
 (if true true (if false true true))
 (pred (if true true false))
 (if true false (succ zero))
 (iszero (if true true false))
 (pred (iszero true))
 (if true false (if true true false))
 (succ (if true false zero))
 (iszero (iszero true))
 (if false false true)
 (if true true (if true false zero))
 (if true false (iszero true))
 (if false true (succ true))
 (succ (succ (succ true)))
 (pred (if true true zero))
 (if true true (succ (succ true)))
 (iszero (if true true zero))
 (pred (pred false))
 (if true false (if true true zero))
 (iszero (pred false))
 (pred (if true false true))
 (if true false (pred false))
 (succ (if true true (succ true)))
 (iszero (if true false true))
 (if true true (if true true (succ true)))
 (if true false (if true false true))
 (succ (if false true false))
 (if true true (if false true false))
 (pred (iszero false))
 (iszero (iszero false))
 (if false false false)
 (if true false (iszero false))
 (if false true (succ false))
 (succ (if true zero true)))

; 3.2.3  Terms, concretely (p. 27)

;;; to do this properly may require union/set constraints: empty-set,
;;; union, intersection, membership.  For example, see
;;;
;;; http://cmpe.emu.edu.tr/bayram/courses/532/ForPresentation/p861-dovier.pdf
;;;
;;; In this case we are dealing with finite domains, correct?  Can we
;;; just add new operators to the finite domain constraints?  Does
;;; there already exist a standard 'set' constraint system?  CLP(sets)

;;; I'd like to be able to write something like this:
;;; (maybe the setos need to be unnested, or just become set constructors (functions, not constraints))
(define S_n
  (lambda (n out)
    (conde
      [(== (build-num 0) n)
       (empty-seto out)]
      [(poso n)
       (fresh (n-1 t1 t2 t3)         
         (minuso n (build-num 1) n-1)
         (S_n n-1 t1)
         (S_n n-1 t2)
         (S_n n-1 t3)
         (uniono (seto 'true 'false 'zero)
                 (seto `(succ ,t1) `(pred ,t1) `(iszero ,t1))
                 (seto `(if ,t1 ,t2 ,t3))
                 out))])))

(define S
  (lambda (out)
    (letrec ([S (lambda (i S_acc out)
                  (fresh (S_i)
                    (S_n i S_i)
                    (uniono
                     S_i
                     S_acc
                     S_i+acc)
                    (conde
                      [(== S_i+acc out)]
                      [(fresh (i+1)
                         (pluso i (build-num 1) i+1)
                         (S i+1 S_i+acc out))])))])
      (fresh (es)
        (empty-seto es)
        (S (build-num 0) es out)))))

;;; Question: Proof in 3.2.6 uses complete (strong) induction.  If
;;; regular induction corresponds to recursive definitions in Scheme,
;;; what would be the Scheme equivalent of complete induction?  Is
;;; this related to the step-indexed relations stuff?  Any relation to
;;; coinduction?
