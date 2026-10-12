;; Casos de prueba de la especificación 06_Data_Structures_Basics.md — GNU Guile + SRFI-64.
;;
;; Contrato: cuatro tipos y un único `Node` compartido, todo inmutable: cada
;; operación devuelve un valor nuevo, así que los escenarios se encadenan con
;; `let*` y no se muta nada. `empty-linked-list`, `empty-stack` y `empty-queue`
;; son el estado inicial (el `init()` de la especificación).
;;
;; Adecuaciones de centinela de la fase (todavía no hay fallos reales): **int
;; → -1** (`linked-list-head`, `stack-peek`, `queue-peek`), **bool → #f**
;; (`linked-list-empty?`, `stack-empty?`, `queue-empty?`) y **nulo (#f) solo para
;; estructuras y nodos**: el enlace ausente de `node-next`, `node-with-next`,
;; `linked-list-insert-head`/`insert-tail`/`delete`, `stack-push`, `queue-enqueue`
;; y el resultado de `stack-pop`/`queue-dequeue`, que es `(cons valor
;; estructura-nueva)` o `#f` cuando está vacía. Los tamaños llevan también el
;; centinela -1 mientras el src sea un esqueleto. No se espera ninguna excepción.
;;
;; Aislamiento: al ser inmutable, las constantes vacías se comparten sin copia;
;; los escenarios de borrado y desapilado reutilizan el mismo valor encadenado.
;;
;; Corrección 4d (2026-10-11): dos defectos de la primera versión, los dos de la
;; trayectoria de los datos y ninguno del contrato:
;;   - «LinkedList size should not change when delete reports failure» comparaba el
;;     mismo borrado dos veces —como lista de tamaño 2 y como #f—: con estructuras
;;     inmutables la segunda comprobación tiene que partir del primer resultado.
;;     Ahora borra sobre lo ya borrado: `(linked-list-delete (linked-list-delete
;;     list 2) 2)`.
;;   - los `let*` internos de Stack y Queue reapuntaban la estructura a `(cdr par)`
;;     antes de desapilar, así que las aserciones de «vacía» miraban una estructura
;;     con un elemento todavía dentro. Ahora sale primero el par y la estructura ya
;;     vaciada, después.

(use-modules (srfi srfi-64))
(load "../src/data_structures_basics.scm")
(use-modules (data_structures_basics))

(test-begin "data_structures_basics")

;; ---------------------------------------------------------------------------
;; Node
;; ---------------------------------------------------------------------------

(test-equal "Node get_value should return the value given to init"
            42
            (node-value (make-node 42 #f)))

(test-equal "Node get_next should be an absent link before node-with-next"
            #f
            (node-next (make-node 42 #f)))

(let((linked (node-with-next (make-node 42 #f) (make-node 7 #f))))
  (test-equal "Node get_next should see the node linked by node-with-next"
              7
              (node-value (node-next linked)))
  (test-equal "Node node-with-next should keep the original value"
              42
              (node-value linked)))

(test-equal "Node node-with-next should accept an absent link"
            #f
            (node-next (node-with-next (make-node 42 #f) #f)))

;; ---------------------------------------------------------------------------
;; LinkedList
;; ---------------------------------------------------------------------------

(test-equal "LinkedList size should be 0 after init"
            0
            (linked-list-size empty-linked-list))

(test-equal "LinkedList is_empty should be true after init"
            #t
            (linked-list-empty? empty-linked-list))

(test-equal "LinkedList get_head should be the failure indicator when empty"
            -1
            (linked-list-head empty-linked-list))

(let((list (linked-list-insert-head empty-linked-list 10)))
  (test-equal "LinkedList get_head should be 10 after inserting 10 into an empty list"
              10
              (linked-list-head list))
  (test-equal "LinkedList size should be 1 after one insert_head"
              1
              (linked-list-size list)))

(let* ((list (linked-list-insert-head empty-linked-list 10))
       (list (linked-list-insert-head list 5)))
  (test-equal "LinkedList get_head should be 5 after inserting 5 at the head"
              5
              (linked-list-head list))
  (test-equal "LinkedList size should be 2 after two insert_head"
              2
              (linked-list-size list))
  (test-equal "LinkedList is_empty should be false with two elements"
              #f
              (linked-list-empty? list)))

(let((list (linked-list-insert-tail empty-linked-list 10)))
  (test-equal "LinkedList get_head should be 10 after the first insert_tail"
              10
              (linked-list-head list))
  (test-equal "LinkedList size should be 1 after one insert_tail"
              1
              (linked-list-size list)))

(let* ((list (linked-list-insert-tail empty-linked-list 10))
       (list (linked-list-insert-tail list 20))
       (list (linked-list-insert-tail list 30)))
  (test-equal "LinkedList get_head should stay 10 when appending at the tail"
              10
              (linked-list-head list))
  (test-equal "LinkedList size should be 3 after three insert_tail"
              3
              (linked-list-size list))
  (let((list (linked-list-insert-head list 5)))
    (test-equal "LinkedList get_head should be the new head after insert_head on a non empty list"
                5
                (linked-list-head list))
    (test-equal "LinkedList size should be 4 after mixing insert_head and insert_tail"
                4
                (linked-list-size list))))

;; Escenario de borrado: cabeza, cola (y reenganche), valor ausente, elemento
;; del medio, único elemento, lista vaciada y reutilización, siempre encadenando
;; el valor que devuelve cada operación.
(let* ((list (linked-list-insert-tail empty-linked-list 10))
       (list (linked-list-insert-tail list 20))
       (list (linked-list-insert-tail list 30))
       (list (linked-list-insert-head list 5)))
  (test-equal "LinkedList size should be 4 before deleting"
              4
              (linked-list-size list))
  (let((list (linked-list-delete list 5)))
    (test-equal "LinkedList get_head should be 10 after the head is removed"
                10
                (linked-list-head list))
    (test-equal "LinkedList size should be 3 after the head is removed"
                3
                (linked-list-size list))
    (let((list (linked-list-delete list 30)))
      (test-equal "LinkedList size should be 2 after the tail is removed"
                  2
                  (linked-list-size list))
      (let((list (linked-list-insert-tail list 40)))
        (test-equal "LinkedList size should be 3 after appending to the list whose tail was removed"
                    3
                    (linked-list-size list))
        (let((list (linked-list-delete list 40)))
          (test-equal "LinkedList delete should find the element appended after the tail was removed"
                      2
                      (linked-list-size list))
          (test-equal "LinkedList delete should report failure for a value that is not stored"
                      #f
                      (linked-list-delete list 99))
          (let((list (linked-list-delete list 20)))
            (test-equal "LinkedList size should be 1 after removing the middle element"
                        1
                        (linked-list-size list))
            (test-equal "LinkedList get_head should be 10 with a single element left"
                        10
                        (linked-list-head list))
            (let((list (linked-list-delete list 10)))
              (test-equal "LinkedList is_empty should be true after the only element is removed"
                          #t
                          (linked-list-empty? list))
              (test-equal "LinkedList get_head should be the failure indicator after the list is emptied"
                          -1
                          (linked-list-head list))
              (test-equal "LinkedList delete should report failure on an empty list"
                          #f
                          (linked-list-delete list 10))
              (let((list (linked-list-insert-head list 1)))
                (test-equal "LinkedList get_head should be 1 after reusing an emptied list"
                            1
                            (linked-list-head list))
                (test-equal "LinkedList size should be 1 after reusing an emptied list"
                            1
                            (linked-list-size list))))))))))

(let* ((list (linked-list-insert-tail empty-linked-list 10))
       (list (linked-list-delete list 10)))
  (test-equal "LinkedList is_empty should be true after the element is removed"
              #t
              (linked-list-empty? list)))

(let* ((list (linked-list-insert-head empty-linked-list 1))
       (list (linked-list-insert-tail list 2))
       (list (linked-list-insert-tail list 3)))
  (test-equal "LinkedList size should be 3 after three insertions"
              3
              (linked-list-size list))
  (test-equal "LinkedList size should be 2 after one removal"
              2
              (linked-list-size (linked-list-delete list 2)))
  (test-equal "LinkedList delete should report failure for a value already removed"
              #f
              (linked-list-delete (linked-list-delete list 2) 2)))

;; ---------------------------------------------------------------------------
;; Stack
;; ---------------------------------------------------------------------------

(test-equal "Stack size should be 0 after init"
            0
            (stack-size empty-stack))

(test-equal "Stack is_empty should be true after init"
            #t
            (stack-empty? empty-stack))

(test-equal "Stack peek should be the failure indicator when empty"
            -1
            (stack-peek empty-stack))

(test-equal "Stack pop should be the failure indicator when empty"
            #f
            (stack-pop empty-stack))

(let((stack (stack-push empty-stack 1)))
  (test-equal "Stack size should be 1 after one push"
              1
              (stack-size stack))
  (test-equal "Stack peek should be the most recently pushed value"
              1
              (stack-peek stack)))

(let* ((stack (stack-push empty-stack 1))
       (stack (stack-push stack 2))
       (stack (stack-push stack 3)))
  (test-equal "Stack size should be 3 after three pushes"
              3
              (stack-size stack))
  (test-equal "Stack peek should be 3 after pushing 3"
              3
              (stack-peek stack))
  (test-equal "Stack is_empty should be false with three elements"
              #f
              (stack-empty? stack))
  (test-equal "Stack pop should return the last pushed value first"
              3
              (car (stack-pop stack)))
  (test-equal "Stack size should be 2 after one pop"
              2
              (stack-size (cdr (stack-pop stack))))
  (let* ((stack (cdr (stack-pop stack)))
         (popped (stack-pop stack)))
    (test-equal "Stack pop should return the next value in LIFO order"
                2
                (car popped))
    (let* ((rest (cdr popped))
           (popped (stack-pop rest))
           (stack (cdr popped)))
      (test-equal "Stack pop should return the first pushed value last"
                  1
                  (car popped))
      (test-equal "Stack size should be 0 after popping every element"
                  0
                  (stack-size stack))
      (test-equal "Stack is_empty should be true after popping every element"
                  #t
                  (stack-empty? stack))
      (test-equal "Stack pop should be the failure indicator on an empty stack"
                  #f
                  (stack-pop stack))
      (test-equal "Stack peek should be the failure indicator after the stack is emptied"
                  -1
                  (stack-peek stack))
      (test-equal "Stack pop should work on a stack reused after being emptied"
                  9
                  (car (stack-pop (stack-push stack 9)))))))

(let* ((stack (stack-push empty-stack 1))
       (stack (stack-push stack 2)))
  (test-equal "Stack peek should return the top value"
              2
              (stack-peek stack))
  (test-equal "Stack peek should not change the size"
              2
              (stack-size stack))
  (test-equal "Stack peek should not consume the value"
              2
              (car (stack-pop stack))))

(let((stack (stack-push empty-stack 1)))
  (test-equal "Stack is_empty should be false with one element"
              #f
              (stack-empty? stack))
  (test-equal "Stack is_empty should be true after the element is popped"
              #t
              (stack-empty? (cdr (stack-pop stack)))))

(test-equal "Stack size should be 0 for a new stack"
            0
            (stack-size empty-stack))

;; ---------------------------------------------------------------------------
;; Queue
;; ---------------------------------------------------------------------------

(test-equal "Queue size should be 0 after init"
            0
            (queue-size empty-queue))

(test-equal "Queue is_empty should be true after init"
            #t
            (queue-empty? empty-queue))

(test-equal "Queue peek should be the failure indicator when empty"
            -1
            (queue-peek empty-queue))

(test-equal "Queue dequeue should be the failure indicator when empty"
            #f
            (queue-dequeue empty-queue))

(let((queue (queue-enqueue empty-queue 1)))
  (test-equal "Queue size should be 1 after one enqueue"
              1
              (queue-size queue))
  (test-equal "Queue peek should be the first enqueued value"
              1
              (queue-peek queue)))

(let* ((queue (queue-enqueue empty-queue 1))
       (queue (queue-enqueue queue 2))
       (queue (queue-enqueue queue 3)))
  (test-equal "Queue size should be 3 after three enqueues"
              3
              (queue-size queue))
  (test-equal "Queue peek should stay at the front when enqueuing"
              1
              (queue-peek queue))
  (test-equal "Queue is_empty should be false with three elements"
              #f
              (queue-empty? queue))
  (test-equal "Queue dequeue should return the first enqueued value first"
              1
              (car (queue-dequeue queue)))
  (test-equal "Queue size should be 2 after one dequeue"
              2
              (queue-size (cdr (queue-dequeue queue))))
  (let* ((queue (cdr (queue-dequeue queue)))
         (dequeued (queue-dequeue queue)))
    (test-equal "Queue dequeue should return the next value in FIFO order"
                2
                (car dequeued))
    (let* ((rest (cdr dequeued))
           (dequeued (queue-dequeue rest))
           (queue (cdr dequeued)))
      (test-equal "Queue dequeue should return the last enqueued value last"
                  3
                  (car dequeued))
      (test-equal "Queue size should be 0 after dequeuing every element"
                  0
                  (queue-size queue))
      (test-equal "Queue is_empty should be true after dequeuing every element"
                  #t
                  (queue-empty? queue))
      (test-equal "Queue dequeue should be the failure indicator on an empty queue"
                  #f
                  (queue-dequeue queue))
      (test-equal "Queue peek should be the failure indicator after the queue is emptied"
                  -1
                  (queue-peek queue))
      (test-equal "Queue dequeue should work on a queue reused after being emptied"
                  9
                  (car (queue-dequeue (queue-enqueue queue 9)))))))

(let* ((queue (queue-enqueue empty-queue 1))
       (queue (queue-enqueue queue 2)))
  (test-equal "Queue peek should return the front value"
              1
              (queue-peek queue))
  (test-equal "Queue peek should not change the size"
              2
              (queue-size queue))
  (test-equal "Queue peek should not consume the value"
              1
              (car (queue-dequeue queue))))

(let((queue (queue-enqueue empty-queue 1)))
  (test-equal "Queue is_empty should be false with one element"
              #f
              (queue-empty? queue))
  (test-equal "Queue is_empty should be true after the element is dequeued"
              #t
              (queue-empty? (cdr (queue-dequeue queue)))))

(test-equal "Queue size should be 0 for a new queue"
            0
            (queue-size empty-queue))

(test-end "data_structures_basics")
