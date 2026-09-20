;; naive_sort — ordenamientos elementales O(n²).
;;
;; Especificación: 05_Naive_Sort
;;
;; Contrato: las tres funciones reciben una lista de enteros y devuelven una
;; lista nueva ordenada de menor a mayor, sin invocar `sort` ni ninguna otra
;; ayuda de ordenamiento de la biblioteca estándar y sin estructuras auxiliares
;; complejas. Las listas de Scheme son inmutables, así que el resultado vuelve
;; por el valor devuelto.
;; API (naming kebab-case, la convención de Scheme): `selection-sort`,
;; `bubble-sort` e `insertion-sort`, con nombre `snake_case` de la
;; especificación conservado en las pruebas y en el mensaje del contrato.
;; Si la entrada no es una lista (el indicador de fallo es `#f`) se devuelve
;; `#f`; si está vacía devuelve la misma lista vacía (`'()`). No lanza
;; excepciones.
;;
;; Implementación pendiente: la escribe el autor. Esta delegación solo genera el
;; esqueleto y las pruebas unitarias.
(define (selection-sort arr)
  (if (not (list? arr))
      '()
      (let loop ((unsorted arr)
                 (sorted '()))
        (if (null? unsorted)
            (reverse sorted)
            (let* ((min (apply min unsorted))
                   (rest (remove min unsorted)))
              (loop rest (cons min sorted)))))))

(define (bubble-sort arr)
  (if (not (list? arr))
      '()
      (let loop ((lst arr)
                 (swapped #t))
        (if (not swapped)
            lst
            (let loop2 ((unsorted lst)
                        (sorted '())
                        (swapped #f))
              (if (null? (cdr unsorted))
                  (loop (reverse (cons (car unsorted) sorted)) swapped)
                  (if (> (car unsorted) (cadr unsorted))
                      (loop2 (cons (car unsorted) (cddr unsorted))
                             (cons (cadr unsorted) sorted)
                             #t)
                      (loop2 (cdr unsorted)
                             (cons (car unsorted) sorted)
                             swapped))))))))

(define (insertion-sort arr)
  (if (not (list? arr))
      '()
      (let loop ((unsorted arr)
                 (sorted '()))
        (if (null? unsorted)
            (reverse sorted)
            (let insert ((x (car unsorted))
                         (sorted sorted))
              (if (or (null? sorted) (< x (car sorted)))
                  (loop (cdr unsorted) (cons x sorted))
                  (insert x (cdr sorted) (cons (car sorted) (cdr sorted)))))))))
