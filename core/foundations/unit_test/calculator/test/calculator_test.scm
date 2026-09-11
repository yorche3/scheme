(load "../src/calculator.scm")
(load "scmunit.scm")

(testcase* "calculator" (list
  (testcase "addition" (list
    (assert = (addition 2 3) 5)))
  (testcase "subtraction" (list
    (assert = (subtraction 5 2) 3)))
  (testcase "multiplication" (list
    (assert = (multiplication 3 4) 12)))
  (testcase "division" (list
    (assert = (division 10 3) 3)))
  (testcase "modulus" (list
    (assert = (modulus 10 3) 1)))))

(scmunit-run*)
