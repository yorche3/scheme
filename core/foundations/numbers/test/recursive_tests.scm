(load "../src/numbers.scm")
(load (or (get-environment-variable "SCMUNIT_PATH") "scmunit.scm"))

(testcase* "recursive" (list
  (testcase "sum_of_first_n_rec" (list
    (assert = (sum_of_first_n_rec 0) 0)
    (assert = (sum_of_first_n_rec 3) 6)))
  (testcase "factorial_rec" (list
    (assert = (factorial_rec 0) 1)
    (assert = (factorial_rec 4) 24)))
  (testcase "fibonacci_rec" (list
    (assert = (fibonacci_rec 0) 0)
    (assert = (fibonacci_rec 1) 1)
    (assert = (fibonacci_rec 6) 8)))
  (testcase "greatest_common_divisor_rec" (list
    (assert = (greatest_common_divisor_rec 12 8) 4)
    (assert = (greatest_common_divisor_rec 7 5) 1)))
  (testcase "least_common_multiple_rec" (list
    (assert = (least_common_multiple_rec 4 6) 12)
    (assert = (least_common_multiple_rec 6 8) 24)))))

(scmunit-run*)
