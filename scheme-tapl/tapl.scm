;; Copyright (C) 2012 William E. Byrd

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in
;; all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;; THE SOFTWARE.

(library
  (tapl)
  (export T? T Sio sizeo)
  (import (rnrs)
          (match)
          (cKanren ck)
          (cKanren fd)
          (cKanren tree-unify)
          (cKanren neq))

  ; 3.2.1  Terms, inductively  (p. 26)  
  (define T?
    (lambda (t)
      (match t
        [true #t]
        [false #t]
        [zero #t]
        [(succ ,[t1]) t1]
        [(pred ,[t1]) t1]
        [(if ,[t1] ,[t2] ,[t3]) (and t1 t2 t3)]
        [,else #f])))

  ; 3.2.2  Terms, by inference rules (p. 26)
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

  ; 3.2.3  Terms, concretely  (p. 27)
  ;
  ; This definition arguably isn't in the spirit of the book, since
  ; the value returned is a single element of the set at the level.
  ; A run* will return all terms at that level (S1, S2, etc).
  ;
  ; An arguably more accurate solution to this problem would use the
  ; equivalent of Prolog's setof predicate to generate a list of
  ; values within the miniKanren program, rather than relying on the
  ; output of a run* to see all elements of the set at each level.
  ;
  ; Here I'm representing numbers as Peano numerals:
  ; z, (s z), (s (s z)), etc.
  ;
  ; The number of terms at each level grows *very* quickly.  Beware
  ; using run* with levels above S2 (a.k.a, (s (s z))).
  (define S1o
    (lambda (n t)
      (fresh ()
        (== '(s z) n)
        (conde
          [(== 'true t)]
          [(== 'false t)]
          [(== 0 t)]))))

  (define Sio
    (lambda (n t)
      (conde
        [(S1o n t)]
        [(fresh (n-2 t1)
           (== `(s (s ,n-2)) n)
           (conde
             [(== `(succ ,t1) t)]
             [(== `(pred ,t1) t)]
             [(== `(iszero ,t1) t)]
             [(fresh (t2 t3)
                (== `(if ,t1 ,t2 ,t3) t)
                (Sio `(s ,n-2) t2)
                (Sio `(s ,n-2) t3))])
           (Sio `(s ,n-2) t1))])))


 

  (define MAXINT (expt 2 32))

  
  ; 3.3.2  Term size (p. 29)
  (define sizeo
    (lambda (t s)
      (fresh ()
        (infd s (range 0 MAXINT))
        (conde
          [(== 1 s)
           (conde
             [(== 'true t)]
             [(== 'false t)]
             [(== 0 t)])]
          [(fresh (t1 s1)
             (conde
               [(== `(succ ,t1) t)]
               [(== `(pred ,t1) t)]
               [(== `(iszero ,t1) t)])
             (infd s1 (range 0 MAXINT))
             (plusfd s1 1 s)
             (sizeo t1 s1))]
          [(fresh (t1 t2 t3 s1 s2 s3 s4 s5)
             (== `(if ,t1 ,t2 ,t3) t)
             (infd s1 s2 s3 s4 s5 (range 0 MAXINT))
             (plusfd s1 s2 s4)
             (plusfd s4 s3 s5)
             (plusfd s5 1 s)
;             (<fd s1 s)
;             (<fd s2 s)
;             (<fd s3 s)
;             (<fd s4 s)
;             (<fd s5 s)
             (sizeo t1 s1)
             (sizeo t2 s2)
             (sizeo t3 s3))]))))
  )


(import (tapl))
