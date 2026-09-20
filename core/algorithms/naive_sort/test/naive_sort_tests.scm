;; Casos de prueba de la especificación 05_Naive_Sort.md — MIT/GNU Scheme + scmunit.
;;
;; Caso nulo incluido: la lista vacía y el valor nulo del contrato coinciden en
;; Scheme (`'()` es la única lista vacía), así que el indicador de fallo es `#f`
;; (lo devuelven las funciones cuando la entrada no es una lista) y se comprueba
;; de forma independiente del caso vacío. No se espera ninguna excepción.
;;
;; Aislamiento: las listas de Scheme son inmutables, así que los tres algoritmos
;; construyen una lista nueva y cada caso puede usar las constantes compartidas
;; sin copiarlas.

(load "../src/naive_sort.scm")
(load (or (get-environment-variable "SCMUNIT_PATH") "scmunit.scm"))

;; Entradas de la especificación
(define standard-input '(5 2 9 1 5 6))
(define standard-output '(1 2 5 5 6 9))

(define sorted-input '(1 2 3 4 5))
(define sorted-output '(1 2 3 4 5))

(define reverse-input '(5 4 3 2 1))
(define reverse-output '(1 2 3 4 5))

(define identical-input '(7 7 7 7))
(define identical-output '(7 7 7 7))

(define negative-input '(3 -1 4 -5 0))
(define negative-output '(-5 -1 0 3 4))

(define single-input '(42))
(define single-output '(42))

(define empty-input '())
(define empty-output '())

(define null-input #f)
(define null-output #f)

;; Tabla de casos: descripción, entrada y salida esperada.
(define cases
  (list
   (list "an unsorted array" standard-input standard-output)
   (list "an already sorted array" sorted-input sorted-output)
   (list "a reverse ordered array" reverse-input reverse-output)
   (list "an array of identical elements" identical-input identical-output)
   (list "an array with negative numbers" negative-input negative-output)
   (list "a single element array" single-input single-output)
   (list "an empty array" empty-input empty-output)
   (list "a null input" null-input null-output)))

;; Helper compartido: recibe el nombre del algoritmo y la función a probar y
;; devuelve el testcase del algoritmo, con un sub-testcase por caso cuyo nombre
;; lleva el mensaje descriptivo del contrato (scmunit no admite mensajes por
;; aserción).
(define (algorithm-testcase algorithm sort-function)
  (testcase algorithm
            (map (lambda (test-case)
                   (testcase (string-append algorithm " should sort "
                                            (list-ref test-case 0))
                             (list (assert equal?
                                           (sort-function (list-ref test-case 1))
                                           (list-ref test-case 2)))))
                 cases)))

(testcase* "naive_sort" (list
  (algorithm-testcase "selection_sort" selection-sort)
  (algorithm-testcase "bubble_sort" bubble-sort)
  (algorithm-testcase "insertion_sort" insertion-sort)))

(scmunit-run*)
