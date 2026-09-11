(use-modules (srfi srfi-64))
(load "../src/numbers.scm")

(test-begin "recursive")

(test-equal "sum_of_first_n_rec: 0" 0 (sum_of_first_n_rec 0))
(test-equal "sum_of_first_n_rec: 3" 6 (sum_of_first_n_rec 3))
(test-equal "factorial_rec: 0" 1 (factorial_rec 0))
(test-equal "factorial_rec: 4" 24 (factorial_rec 4))
(test-equal "fibonacci_rec: 0" 0 (fibonacci_rec 0))
(test-equal "fibonacci_rec: 1" 1 (fibonacci_rec 1))
(test-equal "fibonacci_rec: 6" 8 (fibonacci_rec 6))
(test-equal "greatest_common_divisor_rec: 12,8" 4 (greatest_common_divisor_rec 12 8))
(test-equal "greatest_common_divisor_rec: 7,5" 1 (greatest_common_divisor_rec 7 5))
(test-equal "least_common_multiple_rec: 4,6" 12 (least_common_multiple_rec 4 6))
(test-equal "least_common_multiple_rec: 6,8" 24 (least_common_multiple_rec 6 8))

(test-end "recursive")
