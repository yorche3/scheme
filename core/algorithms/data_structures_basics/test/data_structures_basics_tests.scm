;; data_structures_basics_tests.scm — MIT/GNU Scheme + scmunit.

(load "../src/data_structures_basics.scm")
(load (or (get-environment-variable "SCMUNIT_PATH") "scmunit.scm"))

(testcase* "data_structures_basics" (list))

(scmunit-run*)
