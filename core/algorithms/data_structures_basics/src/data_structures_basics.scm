;; data_structures_basics.scm — GNU Guile
;;
;; Especificación: 06_Data_Structures_Basics
;;
;; Contrato (API pública, toda en kebab-case y con las estructuras inmutables):
;;   Node        make-node, node?, node-value, node-next, node-with-next
;;   LinkedList  make-linked-list, linked-list?, linked-list-empty?, linked-list-head,
;;               linked-list-insert-head, linked-list-insert-tail, linked-list-delete,
;;               linked-list-size
;;   Stack       make-stack, stack?, stack-empty?, stack-push, stack-pop, stack-peek,
;;               stack-size
;;   Queue       make-queue, queue?, queue-empty?, queue-enqueue, queue-dequeue,
;;               queue-peek, queue-size
;;   Estado vacío: empty-linked-list, empty-stack, empty-queue
;;
;; Adecuaciones de centinela de esta fase (todavía no hay fallos reales: son
;; centinelas, uno por tipo de retorno):
;;   - **int → -1**: las lecturas enteras que pueden fallar (`linked-list-head`,
;;     `stack-peek`, `queue-peek`) y los tamaños mientras son esqueletos
;;     (`linked-list-size`, `stack-size`, `queue-size`).
;;   - **bool → #f**: `linked-list-empty?`, `stack-empty?`, `queue-empty?`.
;;   - **Solo las estructuras y los nodos usan nulo (#f)**: el enlace ausente
;;     (`node-next`), `node-with-next`, las operaciones que devuelven una
;;     estructura nueva mientras son esqueletos (`linked-list-insert-head`,
;;     `linked-list-insert-tail`, `linked-list-delete`, `stack-push`,
;;     `queue-enqueue`) y el resultado de `stack-pop`/`queue-dequeue`, que es
;;     `(cons valor estructura-nueva)` o `#f` cuando está vacía.
;;   - Los esqueletos de `stack-pop` y `queue-dequeue` devuelven
;;     `(cons -1 <la misma estructura>)`: el centinela entero viaja en el par.
;;   - Ningún cuerpo llama a `error` ni lanza excepciones: son esqueletos.
;;
;; Forma: módulo de Guile (`define-module`), el idioma de Guile y el estándar
;; acordado para Scheme en este repositorio (Guile-solo: MIT/GNU Scheme no
;; registra módulos de usuario). Las suites hacen `(load "../src/…")` y después
;; `(use-modules (data_structures_basics))`, y se ejecutan con
;; `guile --no-auto-compile -s <suite>_guile.scm`. Los records vienen de SRFI-9.
;;
;; Implementación pendiente: la escribe el autor. Esta delegación solo genera el
;; contrato (firmas y esqueletos) con las adecuaciones de salida.

(define-module (data_structures_basics)
  #:use-module (srfi srfi-9)
  #:export (make-node
            node?
            node-value
            node-next
            node-with-next
            empty-linked-list
            linked-list?
            linked-list-empty?
            linked-list-head
            linked-list-insert-head
            linked-list-insert-tail
            linked-list-delete
            linked-list-size
            empty-stack
            stack?
            stack-empty?
            stack-push
            stack-pop
            stack-peek
            stack-size
            empty-queue
            queue?
            queue-empty?
            queue-enqueue
            queue-dequeue
            queue-peek
            queue-size))

;; ---------------------------------------------------------------------------
;; Node
;; ---------------------------------------------------------------------------

;; Celda enlazada compartida por LinkedList, Stack y Queue.
;; El valor es inmutable tras la construcción; el enlace se da al construir y no
;; se muta: `node-with-next` devuelve una celda nueva.
(define-record-type <node>
  (make-node value next)
  node?
  (value node-value)
  (next node-next))

;; ---------------------------------------------------------------------------
;; LinkedList
;; ---------------------------------------------------------------------------

(define-record-type <linked-list>
  (make-linked-list head tail count)
  linked-list?
  (head linked-list-head-field)
  (tail linked-list-tail-field)
  (count linked-list-count-field))

;; ---------------------------------------------------------------------------
;; Stack
;; ---------------------------------------------------------------------------

(define-record-type <stack>
  (make-stack top count)
  stack?
  (top stack-top-field)
  (count stack-count-field))

;; ---------------------------------------------------------------------------
;; Queue
;; ---------------------------------------------------------------------------

(define-record-type <queue>
  (make-queue front rear count)
  queue?
  (front queue-front-field)
  (rear queue-rear-field)
  (count queue-count-field))

;; Estado vacío de cada estructura (el `init()` de la especificación): sin
;; enlaces (inicio y fin a #f) y contador a cero.
(define empty-linked-list (make-linked-list #f #f 0))
(define empty-stack (make-stack #f 0))
(define empty-queue (make-queue #f #f 0))

;; Esqueleto: devuelve una celda nueva con el enlace reemplazado.
(define (node-with-next node next)
  #f)

;; Esqueleto: valor de la cabeza, o -1 cuando la lista está vacía.
(define (linked-list-head linked-list)
  -1)

;; Esqueleto: #t solo si no hay nodos.
(define (linked-list-empty? linked-list)
  #f)

;; Esqueleto: número de nodos (el centinela es -1 hasta el paso 5).
(define (linked-list-size linked-list)
  -1)

;; Esqueleto: devuelve una lista nueva con `value` al principio.
(define (linked-list-insert-head linked-list value)
  #f)

;; Esqueleto: devuelve una lista nueva con `value` al final.
(define (linked-list-insert-tail linked-list value)
  #f)

;; Esqueleto: devuelve una lista nueva sin la primera aparición de `value`,
;; o #f si el valor no estaba. O(n).
(define (linked-list-delete linked-list value)
  #f)

;; Esqueleto: #t solo si no hay nodos.
(define (stack-empty? stack)
  #f)

;; Esqueleto: número de nodos (el centinela es -1 hasta el paso 5).
(define (stack-size stack)
  -1)

;; Esqueleto: devuelve una pila nueva con `value` en la cima.
(define (stack-push stack value)
  #f)

;; Esqueleto: (cons valor pila-nueva) o #f cuando está vacía.
(define (stack-pop stack)
  (cons -1 stack))

;; Esqueleto: valor de la cima, o -1 cuando está vacía. No muta.
(define (stack-peek stack)
  -1)

;; Esqueleto: #t solo si no hay nodos.
(define (queue-empty? queue)
  #f)

;; Esqueleto: número de nodos (el centinela es -1 hasta el paso 5).
(define (queue-size queue)
  -1)

;; Esqueleto: devuelve una cola nueva con `value` al final.
(define (queue-enqueue queue value)
  #f)

;; Esqueleto: (cons valor cola-nueva) o #f cuando está vacía.
(define (queue-dequeue queue)
  (cons -1 queue))

;; Esqueleto: valor del frente, o -1 cuando está vacía. No muta.
(define (queue-peek queue)
  -1)
