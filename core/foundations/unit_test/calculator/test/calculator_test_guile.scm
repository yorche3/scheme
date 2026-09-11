(use-modules (srfi srfi-64))
(load "../src/calculator.scm")

(test-begin "calculator")

(test-equal "addition" 5 (addition 2 3))
(test-equal "subtraction" 3 (subtraction 5 2))
(test-equal "multiplication" 12 (multiplication 3 4))
(test-equal "division" 3 (division 10 3))
(test-equal "modulus" 1 (modulus 10 3))

(test-end "calculator")
