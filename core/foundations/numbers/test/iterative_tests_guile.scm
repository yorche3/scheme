(use-modules (srfi srfi-64))
(load "../src/numbers.scm")

(test-begin "iterative")

(test-equal "sum_of_first_n_ite: 0" 0 (sum_of_first_n_ite 0))
(test-equal "sum_of_first_n_ite: 3" 6 (sum_of_first_n_ite 3))
(test-equal "factorial_ite: 0" 1 (factorial_ite 0))
(test-equal "factorial_ite: 4" 24 (factorial_ite 4))
(test-equal "fibonacci_ite: 0" 0 (fibonacci_ite 0))
(test-equal "fibonacci_ite: 1" 1 (fibonacci_ite 1))
(test-equal "fibonacci_ite: 6" 8 (fibonacci_ite 6))
(test-equal "greatest_common_divisor_ite: 12,8" 4 (greatest_common_divisor_ite 12 8))
(test-equal "greatest_common_divisor_ite: 7,5" 1 (greatest_common_divisor_ite 7 5))
(test-equal "least_common_multiple_ite: 4,6" 12 (least_common_multiple_ite 4 6))
(test-equal "least_common_multiple_ite: 6,8" 24 (least_common_multiple_ite 6 8))

(test-end "iterative")
