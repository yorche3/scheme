(load "../src/numbers.scm")
(load (or (get-environment-variable "SCMUNIT_PATH") "scmunit.scm"))

(testcase* "recursive_with_accumulator" (list
  (testcase "sum_of_first_n_acc" (list
    (assert = (sum_of_first_n_acc 0) 0)
    (assert = (sum_of_first_n_acc 3) 6)))
  (testcase "factorial_acc" (list
    (assert = (factorial_acc 0) 1)
    (assert = (factorial_acc 4) 24)))
  (testcase "fibonacci_acc" (list
    (assert = (fibonacci_acc 0) 0)
    (assert = (fibonacci_acc 1) 1)
    (assert = (fibonacci_acc 6) 8)))
  (testcase "greatest_common_divisor_acc" (list
    (assert = (greatest_common_divisor_acc 12 8) 4)
    (assert = (greatest_common_divisor_acc 7 5) 1)))
  (testcase "least_common_multiple_acc" (list
    (assert = (least_common_multiple_acc 4 6) 12)
    (assert = (least_common_multiple_acc 6 8) 24)))))

(scmunit-run*)
