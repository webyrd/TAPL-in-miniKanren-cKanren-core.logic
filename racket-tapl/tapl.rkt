#lang cKanren

;;; Dependencies:  Racket and cKanren (https://github.com/calvis/cKanren)
(require cKanren/miniKanren)
(require cKanren/sets)


; 3.2.3  Terms, concretely (p. 27)
; Defined using CLP(Set) and Peano numbers (z, (s z), (s (s z)), etc.)
; Adapted from @namin's https://github.com/namin/clpset-miniKanren/blob/master/tapl.scm
;
; Alas, this code is slowwwwwww
(define S
  (lambda (i s)
    (conde
      ((== 'z i) (== (empty-set) s))
      ((fresh (i-1 S-1 S-11 S-111 S-succ S-pred S-iszero S-if s1 s2 s3)
         (== `(s ,i-1) i)
         (S i-1 S-1)
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
         (uniono (empty-set) (make-set '(true false zero)) S-succ s1)
         (uniono s1 S-pred s2)
         (uniono s2 S-iszero s3)
         (uniono s3 S-if s))))))

(define mini-S
  (lambda (i s)
    (conde
     ((== 'z i) (== (empty-set) s))
     ((fresh (i-1 S-1 S-11 S-succ S-plus s1)
        (== `(s ,i-1) i)
        (mini-S i-1 S-1)
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


(run 1 (q) (map-seto (lambda (x out) (== `(,x) out))
                     (make-set '(a b c))
                     q))
; '({ (a) (b) (c) | ∅ })

(length
 (run 6 (q) (map-seto (lambda (x out) (== `(,x) out))
                     (make-set '(a b c))
                     q)))
; 6

;;; appears to diverge, as does run7
(length
 (run* (q) (map-seto (lambda (x out) (== `(,x) out))
                     (make-set '(a b c))
                     q)))
; 6

(run 1 (q) (cartesiano (make-set '(a b c)) (make-set '(1 2 3)) q))
; '((set ∅ (a 1) (a 2) (a 3) (b 1) (b 2) (b 3) (c 1) (c 2) (c 3)))

(length (run* (q) (cartesiano (make-set '(a b)) (make-set '(1 2)) q)))
; 1

 (run 1 (q) (S 'z q))
; '(∅)

(run 1 (q) (S '(s z) q))
; '((set ∅ false true zero))

(run 1 (q) (mini-S '(s (s z)) q))
 ;; '((set ∅
 ;;    (plus false false) (plus false true) (plus false zero)
 ;;    (plus true false) (plus true true) (plus true zero)
 ;;    (plus zero false) (plus zero true) (plus zero zero)
 ;;    (succ false) (succ true) (succ zero) false true zero))


; 3.2.3  Terms, concretely (p. 27)
; Defined using CLP(Set) and Peano numbers (z, (s z), (s (s z)), etc.)
; This is super busted, since we'd need to perform setof to accumulate all the answers
;; (define So
;;   (lambda (i Si)
;;     (conde
;;       [(== 'z i) (== (empty-set) Si)]
;;       [(== '(s z) i)
;;        (fresh (Sa Sb)
;;          (uniono (empty-set) (make-set '(true false 0)) Si))]
;;       [(fresh (i-1 i-2 Si-1 t1 t2 t3 Sa Sb)
;;          (== `(s ,i-1) i)
;;          (== `(s ,i-2) i-1)
;;          (So i-1 Si-1)
;;          (ino t1 Si-1)
;;          (ino t2 Si-1)
;;          (ino t3 Si-1)
;;          (uniono (empty-set) (make-set '(true false 0)) Sa)
;;          (uniono Sa (make-set `((succ ,t1) (pred ,t1) (iszero ,t1))) Sb)
;;          (uniono Sb (make-set `((if ,t1, t2 ,t3))) Si))])))

;;; I'm a Racket nub, and don't know how to properly turn these runs into tests
;; (run* (q) (So 'z q)) ; => empty set
;; (run* (q) (So '(s z) q)) ; => (true false 0 succ pred iszero if)
;; (run* (q) (So '(s (s z)) q))
; =>
; (true false 0
; (succ true) (succ false) (succ 0) (succ succ) (succ pred) (succ iszero) (succ if)
; (pred true) (pred false) (pred 0) (pred succ) (pred pred) (pred iszero) (pred if)
; (iszero true) (iszero false) (iszero 0) (iszero succ) (iszero pred) (iszero iszero) (iszero if)
; (if true true true) (if true true false) ... (if if if if)
; )
;; (run* (q) (So '(s (s (s z))) q))
