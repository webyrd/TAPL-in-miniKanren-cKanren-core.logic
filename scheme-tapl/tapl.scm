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
  (tapl-ck)
  (export T? T uniono seto)
  (import (rnrs)
          (match)
          (cKanren ck)
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

  ; 3.2.3  Terms, concretely (p. 27)
;;; To do this properly will require adding set constraints to cKanren (CLP(Set)).
;;; For example, see:
;;;
;;; http://cmpe.emu.edu.tr/bayram/courses/532/ForPresentation/p861-dovier.pdf
  
  )

(import (tapl-ck))
