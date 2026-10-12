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
;; Indicadores de esta fase (no hay fallos reales: son centinelas, uno por tipo
;; de retorno):
;;   - **int → -1**: las lecturas enteras que pueden fallar
;;     (`linked-list-head`, `stack-peek`, `queue-peek`).
;;   - **bool → #t/#f**: `linked-list-empty?`, `stack-empty?`, `queue-empty?`.
;;   - **Solo las estructuras y los nodos usan nulo (#f)**: el enlace ausente
;;     (`node-next`), `linked-list-delete` cuando el valor no estaba o la lista ya
;;     estaba vacía, y el resultado de `stack-pop`/`queue-dequeue`, que es
;;     `(cons valor estructura-nueva)` o #f cuando está vacía.
;;   - Ningún cuerpo llama a `error` ni lanza excepciones.
;;
;; Forma: módulo de Guile (`define-module`), el idioma de Guile y el estándar
;; acordado para Scheme en este repositorio (Guile-solo: MIT/GNU Scheme no
;; registra módulos de usuario). Las suites hacen `(load "../src/…")` y después
;; `(use-modules (data_structures_basics))`, y se ejecutan con
;; `guile --no-auto-compile -s <suite>_guile.scm`. Los records vienen de SRFI-9.
;;
;; Decisiones de implementación (las recoge el README del lenguaje):
;;   - Los `Node` y las tres estructuras son **inmutables**: cada operación
;;     devuelve un valor nuevo en vez de mutar. Por eso `linked-list-insert-tail`
;;     y `queue-enqueue` son **O(n)** —hay que rehacer el último enlace y, con
;;     nodos inmutables, todo el camino que llega hasta él— frente al O(1) que
;;     pide la especificación. El resto conserva la complejidad prometida:
;;     `insert-head` y `push`, O(1); `size`, `is_empty`, `head`, `peek` y
;;     `pop`/`dequeue`, O(1) sobre `head`/`top`/`front` y el contador; `delete`,
;;     O(n).
;;   - `LinkedList` mantiene `head`, `tail` y `count`; `Stack`, `top` y `count`;
;;     `Queue`, `front`, `rear` y `count`. `tail` y `rear` se recalculan en las
;;     operaciones que reconstruyen la cadena, para seguir señalando el último
;;     nodo: borrar la cola y volver a insertar por el final sigue encontrando lo
;;     insertado.
;;   - `delete` borra la primera aparición y devuelve la lista nueva —puede quedar
;;     vacía—; devuelve #f si el valor no estaba o si la lista ya estaba vacía.
;;   - `pop`/`dequeue` devuelven `(cons valor estructura-nueva)` en éxito y #f si
;;     la estructura está vacía: el valor y la estructura resultante viajan
;;     juntos sin mutar nada.

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

;; ---------------------------------------------------------------------------
;; Ayudantes internos (no exportados): recorrer y reconstruir cadenas de nodos.
;; ---------------------------------------------------------------------------

;; Valores de la cadena, en orden.
(define (chain-values head)
  (let loop ((node head) (seen '()))
    (if node
        (loop (node-next node) (cons (node-value node) seen))
        (reverse seen))))

;; Cadena nueva a partir de valores en orden; devuelve (cons cabeza ultimo-nodo)
;; o (cons #f #f) si no hay valores.
(define (chain-from-values elements)
  (let loop ((rest (reverse elements)) (next #f) (last #f))
    (if (null? rest)
        (cons next last)
        (let ((node (make-node (car rest) next)))
          (loop (cdr rest) node (if last last node))))))

;; Quita la primera aparición de `value`; devuelve el par
;; (restantes . encontrado?).
(define (remove-first-value elements value)
  (let loop ((rest elements) (kept '()))
    (cond ((null? rest) (cons (reverse kept) #f))
          ((equal? (car rest) value)
           (cons (append (reverse kept) (cdr rest)) #t))
          (else (loop (cdr rest) (cons (car rest) kept))))))

;; LinkedList reconstruida desde valores en orden, con la cola reenganchada.
(define (linked-list-from-values elements)
  (let ((chain (chain-from-values elements)))
    (make-linked-list (car chain) (cdr chain) (length elements))))

;; Devuelve una celda nueva con el valor de `node` y el enlace reemplazado: el
;; `set_next` de la especificación expresado en un lenguaje inmutable.
(define (node-with-next node next)
  (make-node (node-value node) next))

;; Valor de la cabeza, o -1 cuando la lista está vacía. No muta.
(define (linked-list-head linked-list)
  (let ((head (linked-list-head-field linked-list)))
    (if head (node-value head) -1)))

;; #t solo si no hay nodos. O(1) sobre el enlace de cabeza.
(define (linked-list-empty? linked-list)
  (not (linked-list-head-field linked-list)))

;; Número de nodos. O(1) sobre el contador.
(define (linked-list-size linked-list)
  (linked-list-count-field linked-list))

;; Inserta `value` al principio y devuelve la lista nueva. O(1).
(define (linked-list-insert-head linked-list value)
  (let* ((head (linked-list-head-field linked-list))
         (node (make-node value head))
         (tail (linked-list-tail-field linked-list)))
    (make-linked-list node
                      (if tail tail node)
                      (+ 1 (linked-list-count-field linked-list)))))

;; Inserta `value` al final y devuelve la lista nueva. O(n): los nodos son
;; inmutables y el último enlace solo se puede rehacer copiando el camino.
(define (linked-list-insert-tail linked-list value)
  (linked-list-from-values
   (append (chain-values (linked-list-head-field linked-list))
           (list value))))

;; Borra la primera aparición de `value` y devuelve la lista nueva —puede quedar
;; vacía—; #f si el valor no estaba o si la lista ya estaba vacía. O(n).
(define (linked-list-delete linked-list value)
  (let ((result (remove-first-value
                 (chain-values (linked-list-head-field linked-list))
                 value)))
    (if (cdr result)
        (linked-list-from-values (car result))
        #f)))

;; #t solo si no hay nodos. O(1) sobre la cima.
(define (stack-empty? stack)
  (not (stack-top-field stack)))

;; Número de nodos. O(1) sobre el contador.
(define (stack-size stack)
  (stack-count-field stack))

;; Apila `value` sobre `top` y devuelve la pila nueva. O(1).
(define (stack-push stack value)
  (make-stack (make-node value (stack-top-field stack))
              (+ 1 (stack-count-field stack))))

;; Desapila: (cons valor pila-nueva); #f cuando está vacía. O(1).
(define (stack-pop stack)
  (let ((top (stack-top-field stack)))
    (if top
        (cons (node-value top)
              (make-stack (node-next top)
                          (- (stack-count-field stack) 1)))
        #f)))

;; Valor de la cima, o -1 cuando está vacía. No muta.
(define (stack-peek stack)
  (let ((top (stack-top-field stack)))
    (if top (node-value top) -1)))

;; #t solo si no hay nodos. O(1) sobre el frente.
(define (queue-empty? queue)
  (not (queue-front-field queue)))

;; Número de nodos. O(1) sobre el contador.
(define (queue-size queue)
  (queue-count-field queue))

;; Encola `value` por `rear` y devuelve la cola nueva. O(n): los nodos son
;; inmutables y el último enlace solo se puede rehacer copiando el camino.
(define (queue-enqueue queue value)
  (let* ((elements (append (chain-values (queue-front-field queue))
                           (list value)))
         (chain (chain-from-values elements)))
    (make-queue (car chain) (cdr chain) (length elements))))

;; Desencola: (cons valor cola-nueva); #f cuando está vacía. O(1): `front` avanza
;; un nodo y el último nodo no cambia salvo que la cola quede vacía.
(define (queue-dequeue queue)
  (let ((front (queue-front-field queue)))
    (if front
        (let ((next (node-next front)))
          (cons (node-value front)
                (make-queue next
                            (if next (queue-rear-field queue) #f)
                            (- (queue-count-field queue) 1))))
        #f)))

;; Valor del frente, o -1 cuando está vacía. No muta.
(define (queue-peek queue)
  (let ((front (queue-front-field queue)))
    (if front (node-value front) -1)))
