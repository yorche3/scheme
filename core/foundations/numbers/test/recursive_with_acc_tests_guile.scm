(use-modules (srfi srfi-64))
(load "../src/numbers.scm")

(test-begin "recursive_with_accumulator")

(test-equal "sum_of_first_n_acc: 0" 0 (sum_of_first_n_acc 0))
(test-equal "sum_of_first_n_acc: 3" 6 (sum_of_first_n_acc 3))
(test-equal "factorial_acc: 0" 1 (factorial_acc 0))
(test-equal "factorial_acc: 4" 24 (factorial_acc 4))
(test-equal "fibonacci_acc: 0" 0 (fibonacci_acc 0))
(test-equal "fibonacci_acc: 1" 1 (fibonacci_acc 1))
(test-equal "fibonacci_acc: 6" 8 (fibonacci_acc 6))
(test-equal "greatest_common_divisor_acc: 12,8" 4 (greatest_common_divisor_acc 12 8))
(test-equal "greatest_common_divisor_acc: 7,5" 1 (greatest_common_divisor_acc 7 5))
(test-equal "least_common_multiple_acc: 4,6" 12 (least_common_multiple_acc 4 6))
(test-equal "least_common_multiple_acc: 6,8" 24 (least_common_multiple_acc 6 8))

(test-end "recursive_with_accumulator")
