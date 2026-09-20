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
;; Elimina la primera aparición de x; `remove` es de SRFI-1 y no está en el
;; entorno base de Guile ni de MIT/GNU Scheme.
(define (remove-first x lst)
  (cond ((null? lst) '())
        ((= (car lst) x) (cdr lst))
        (else (cons (car lst) (remove-first x (cdr lst))))))

(define (selection-sort arr)
  (if (not (list? arr))
      #f
      (let loop ((unsorted arr)
                 (sorted '()))
        (if (null? unsorted)
            (reverse sorted)
            (let* ((min (apply min unsorted))
                   (rest (remove-first min unsorted)))
              (loop rest (cons min sorted)))))))

(define (bubble-sort arr)
  (if (not (list? arr))
      #f
      (if (or (null? arr) (null? (cdr arr)))
          arr
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
                                 swapped)))))))))

(define (insertion-sort arr)
  (if (not (list? arr))
      #f
      (let loop ((unsorted arr)
                 (sorted '()))
        (if (null? unsorted)
            sorted
            (loop (cdr unsorted)
                  (let insert ((x (car unsorted))
                               (pending sorted))
                    (cond ((null? pending) (list x))
                          ((< x (car pending)) (cons x pending))
                          (else (cons (car pending)
                                      (insert x (cdr pending)))))))))))
