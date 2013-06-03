#lang cKanren

;;; Dependencies:  Racket and cKanren (https://github.com/calvis/cKanren)
(require cKanren/miniKanren)
(require cKanren/neq)
(require cKanren/absento)
(require cKanren/sets)

(provide (all-defined-out))


; 3.2.3  Terms, concretely (p. 27)
; Defined using CLP(Set) and Peano numbers (z, (s z), (s (s z)), etc.)
; Adapted from @namin's https://github.com/namin/clpset-miniKanren/blob/master/tapl.scm
;
; Alas, this code is slowwwwwww
(define So
  (lambda (i s)
    (conde
      ((== 'z i) (== (empty-set) s))
      ((fresh (i-1 S-1 S-11 S-111 S-succ S-pred S-iszero S-if s1 s2 s3)
         (== `(s ,i-1) i)
         (So i-1 S-1)
         (map-seto (lambda (e o) (== `(succ ,e) o)) S-1 S-succ)
         (map-seto (lambda (e o) (== `(pred ,e) o)) S-1 S-pred)
         (map-seto (lambda (e o) (== `(iszero ,e) o)) S-1 S-iszero)
         (cartesiano S-1 S-1 S-11)
         (cartesiano S-1 S-11 S-111)
         (map-seto (lambda (e o)
                     (fresh (e1 e2 e3)
                       (== `(,e1 (,e2 ,e3)) e)
                       (== `(if ,e1 ,e2 ,e3) o)))
                   S-111
                   S-if)
         (uniono (make-set '(true false zero)) S-succ s1)
         (uniono s1 S-pred s2)
         (uniono s2 S-iszero s3)
         (uniono s3 S-if s))))))

(define mini-So
  (lambda (i s)
    (conde
     ((== 'z i) (== (empty-set) s))
     ((fresh (i-1 S-1 S-11 S-succ S-plus s1)
        (== `(s ,i-1) i)
        (mini-So i-1 S-1)
        (map-seto (lambda (e o) (== `(succ ,e) o)) S-1 S-succ)
        (cartesiano S-1 S-1 S-11)
        (map-seto (lambda (e o)
                    (fresh (e1 e2)
                      (== `(,e1 ,e2) e)
                      (== `(plus ,e1 ,e2) o)))
                  S-11
                  S-plus)
        (uniono (make-set '(true false zero)) S-succ s1)
        (uniono s1 S-plus s))))))

(define map-seto
  (lambda (fo s out)
    (conde
      ((== (empty-set) s)
       (== (empty-set) out))
      ((fresh (se sr oe or)
         (== (set `(,se) sr) s)
         (!ino se sr)
         (fo se oe)
         (map-seto fo sr or)
         (== (set `(,oe) or) out)
         (!ino oe or))))))

(define cartesiano
  (lambda (a b out)
    (conde
      ((== (empty-set) a)
       (== (empty-set) out))
      ((fresh (ae ar o1 or)
         (== (set `(,ae) ar) a)
         (!ino ae ar)
         (map-seto (lambda (be oe) (== `(,ae ,be) oe)) b o1)
         (cartesiano ar b or)
         (uniono o1 or out))))))



; 3.3.1  Induction on Terms (p. 29)

(define Constso
  (lambda (t out)
    (conde
      [(== 'true t) (== (make-set '(true)) out)]
      [(== 'false t) (== (make-set '(false)) out)]
      [(== 0 t) (== (make-set '(0)) out)]
      [(fresh (t1)
         (== `(succ ,t1) t)
         (Constso t1 out))]
      [(fresh (t1)
         (== `(pred ,t1) t)
         (Constso t1 out))]
      [(fresh (t1)
         (== `(iszero ,t1) t)
         (Constso t1 out))]
      [(fresh (t1 t2 t3 res1 res2 res3 res4)
         (== `(if ,t1 ,t2 ,t3) t)
         (Constso t1 res1)
         (Constso t2 res2)
         (Constso t3 res3)
         (uniono res1 res2 res4)
         (uniono res4 res3 out))])))



(module+ test
  (require cKanren/tester)

  (test "map-seto-1"
    (run 1 (q)
      (map-seto
       (lambda (x out)
         (== `(,x) out))
       (make-set '(a b c))
       q))
    (list (make-set '((a) (b) (c)))))

  (test "map-seto-2"
    (length
     (run 6 (q)
       (map-seto
        (lambda (x out)
          (== `(,x) out))
        (make-set '(a b c))
        q)))
    6)

  ;; (test "map-seto-3"
  ;;   ;;; appears to diverge, as does run7
  ;;   (length
  ;;    (run* (q)
  ;;      (map-seto
  ;;       (lambda (x out) (== `(,x) out))
  ;;       (make-set '(a b c))
  ;;       q)))
  ;;   6)

  ;; (test "cartesiano-1"
  ;;   ;;; takes too long...
  ;;   (run 1 (q) (cartesiano (make-set '(a b c)) (make-set '(1 2 3)) q))
  ;;   '((set ∅ (a 1) (a 2) (a 3) (b 1) (b 2) (b 3) (c 1) (c 2) (c 3))))

  (test "cartesiano-2"
    (length (run 1 (q) (cartesiano (make-set '(a b)) (make-set '(1 2)) q)))
    1)

  ;; (test "cartesiano-3"
  ;;   ;;; takes too long...
  ;;   (length (run* (q) (cartesiano (make-set '(a b)) (make-set '(1 2)) q)))
  ;;   1)

  (test "So-1"
    (run 1 (q) (So 'z q))
    (list (empty-set)))

  (test "So-2"
    (run 1 (q) (So '(s z) q))
    (list (make-set '(false true zero))))

  ;; (test "mini-So-1"
  ;;   ;;; takes too long
  ;;   (run 1 (q) (mini-So '(s (s z)) q))
  ;;   '((set ∅
  ;;      (plus false false) (plus false true) (plus false zero)
  ;;      (plus true false) (plus true true) (plus true zero)
  ;;      (plus zero false) (plus zero true) (plus zero zero)
  ;;      (succ false) (succ true) (succ zero) false true zero)))


  (test "Constso-1"
    (run 1 (q) (Constso 'true q))
    (list (make-set '(true))))

  (test "Constso-2"
    (run 1 (q) (Constso 'false q))
    (list (make-set '(false))))

  (test "Constso-3"
    (run 1 (q) (Constso 0 q))
    (list (make-set '(0))))

  (test "Constso-4"
    (run 1 (q) (Constso `(pred true) q))
    (list (make-set '(true))))

  (test "Constso-5"
;;; Hmmm. run 2 generates duplicate answers.    
    (run 1 (q) (Constso `(if true (succ (pred (succ 0))) (succ (succ 0))) q))
    (list (make-set '(0 true))))

  (test "Constso-6"
    (run 3 (q) (fresh (t c) (Constso t c) (== `(,t ,c) q)))
    `((true ,(make-set '(true)))
      (false ,(make-set '(false)))
      (0 ,(make-set '(0)))))
  
)
