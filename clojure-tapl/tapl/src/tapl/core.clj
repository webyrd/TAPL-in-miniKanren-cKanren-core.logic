(ns tapl.core
  (:refer-clojure :exclude [==])
  (:use clojure.core.logic)
  (:use [clojure.core.match :only [match]]))

; 3.2.1  Terms, inductively  (p. 26)
(defn T? [t]
  (match t
    :true true
    :false true
    :zero true
    [:succ t1] (T? t1)
    [:pred t1] (T? t1)
    [:if t1 t2 t3] (and (T? t1) (T? t2) (T? t3))
    :else false))

; 3.2.2  Terms, by inference rules (p. 26)
(defn T [t]
  (conde
    [(== :true t)]
    [(== :false t)]
    [(== :zero t)]
    [(fresh [t1]
       (conde
         [(== [:succ t1] t)]
         [(== [:pred t1] t)]
         [(== [:iszero t1] t)])
       (T t1))]
   [(fresh [t1 t2 t3]
      (== [:if t1 t2 t3] t)
      (T t1)
      (T t2)
      (T t3))]))
