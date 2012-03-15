(ns tapl.test.core
  (:use [tapl.core])
  (:refer-clojure :exclude [==])
  (:use [clojure.core.logic :exclude [is]])
  (:use [clojure.core.match :only [match]])  
  (:use [clojure.test])
  )

(deftest test-T
  (is (= (run* [q] (T :true)) '(_.0)))
  (is (= (run* [q] (T :false)) '(_.0)))
  (is (= (run* [q] (T :zero)) '(_.0)))
  (is (= (run* [q] (T [:succ [:succ [:pred :zero]]])) '(_.0)))
  (is (= (run* [q] (T [:succ [:succ [:pred :false]]])) '(_.0)))
  (is (= (run* [q] (T [:succ [:succ [:pred :foo]]])) '()))
  (is (= (run* [q] (T [:if :false [:succ :zero] [:pred [:succ :zero]]])) '(_.0)))
  (is (= (run* [q] (T [:if :false [:succ :foo] [:pred [:succ :zero]]])) '()))  
  (is (= (run 100 [q] (T q)))
      '(:true
        :false
        :zero
        [:succ :true]
        [:succ :false]
        [:if :true :true :true]
        [:succ :zero]
        [:if :true :true :false]
        [:pred :true]
        [:if :true :true :zero]
        [:pred :false]
        [:if :true :false :true]
        [:iszero :true]
        [:pred :zero]
        [:if :true :false :false]
        [:iszero :false]
        [:if :true :false :zero]
        [:iszero :zero]
        [:succ [:succ :true]]
        [:if :true :zero :true]
        [:if :true :true [:succ :true]]
        [:succ [:succ :false]]
        [:if :true :zero :false]
        [:succ [:if :true :true :true]]
        [:if :true :true [:succ :false]]
        [:if :true :true [:if :true :true :true]]
        [:succ [:succ :zero]]
        [:if :true :zero :zero]
        [:succ [:if :true :true :false]]
        [:if :true :true [:succ :zero]]
        [:succ [:pred :true]]
        [:if :true :true [:if :true :true :false]]
        [:if :false :true :true]
        [:if :true :true [:pred :true]]
        [:succ [:if :true :true :zero]]
        [:pred [:succ :true]]
        [:if :true :true [:if :true :true :zero]]
        [:if :true :false [:succ :true]]
        [:iszero [:succ :true]]
        [:succ [:pred :false]]
        [:if :false :true :false]
        [:succ [:if :true :false :true]]
        [:if :true :true [:pred :false]]
        [:if :true :true [:if :true :false :true]]
        [:pred [:succ :false]]
        [:succ [:iszero :true]]
        [:if :true :true [:iszero :true]]
        [:pred [:if :true :true :true]]
        [:if :true :false [:succ :false]]
        [:iszero [:succ :false]]
        [:if :true :false [:if :true :true :true]]
        [:succ [:pred :zero]]
        [:iszero [:if :true :true :true]]
        [:if :false :true :zero]
        [:succ [:if :true :false :false]]
        [:if :true :true [:pred :zero]]
        [:if :true :true [:if :true :false :false]]
        [:pred [:succ :zero]]
        [:succ [:iszero :false]]
        [:if :true :true [:iszero :false]]
        [:pred [:if :true :true :false]]
        [:if :true :false [:succ :zero]]
        [:iszero [:succ :zero]]
        [:pred [:pred :true]]
        [:if :true :false [:if :true :true :false]]
        [:iszero [:if :true :true :false]]
        [:succ [:if :true :false :zero]]
        [:if :true :false [:pred :true]]
        [:if :true :true [:if :true :false :zero]]
        [:iszero [:pred :true]]
        [:succ [:iszero :zero]]
        [:if :true :true [:iszero :zero]]
        [:pred [:if :true :true :zero]]
        [:if :true :false [:if :true :true :zero]]
        [:iszero [:if :true :true :zero]]
        [:succ [:succ [:succ :true]]]
        [:if :true :zero [:succ :true]]
        [:if :true :true [:succ [:succ :true]]]
        [:succ [:if :true :zero :true]]
        [:if :true :true [:if :true :zero :true]]
        [:succ [:if :true :true [:succ :true]]]
        [:pred [:pred :false]]
        [:if :true :true [:if :true :true [:succ :true]]]
        [:pred [:if :true :false :true]]
        [:if :true :false [:pred :false]]
        [:iszero [:pred :false]]
        [:if :true :false [:if :true :false :true]]
        [:iszero [:if :true :false :true]]
        [:if :false :false :true]
        [:pred [:iszero :true]]
        [:if :true :false [:iszero :true]]
        [:succ [:succ [:succ :false]]]
        [:iszero [:iszero :true]]
        [:if :true :zero [:succ :false]]
        [:if :true :true [:succ [:succ :false]]]
        [:succ [:if :true :zero :false]]
        [:succ [:succ [:if :true :true :true]]]
        [:if :true :true [:if :true :zero :false]]
        [:if :true :zero [:if :true :true :true]]
        [:succ [:if :true :true [:succ :false]]]))
  )
