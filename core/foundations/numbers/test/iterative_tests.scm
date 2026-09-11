(load "../src/numbers.scm")
(load (or (get-environment-variable "SCMUNIT_PATH") "scmunit.scm"))

(testcase* "iterative" (list
  (testcase "sum_of_first_n_ite" (list
    (assert = (sum_of_first_n_ite 0) 0)
    (assert = (sum_of_first_n_ite 3) 6)))
  (testcase "factorial_ite" (list
    (assert = (factorial_ite 0) 1)
    (assert = (factorial_ite 4) 24)))
  (testcase "fibonacci_ite" (list
    (assert = (fibonacci_ite 0) 0)
    (assert = (fibonacci_ite 1) 1)
    (assert = (fibonacci_ite 6) 8)))
  (testcase "greatest_common_divisor_ite" (list
    (assert = (greatest_common_divisor_ite 12 8) 4)
    (assert = (greatest_common_divisor_ite 7 5) 1)))
  (testcase "least_common_multiple_ite" (list
    (assert = (least_common_multiple_ite 4 6) 12)
    (assert = (least_common_multiple_ite 6 8) 24)))))

(scmunit-run*)
