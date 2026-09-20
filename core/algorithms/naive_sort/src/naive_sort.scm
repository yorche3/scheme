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
