;; data_structures_advanced — Node, TreeNode, BinaryTree, GraphNode y Graph.
;;
;; Especificación: 07_Data_Structures_Advanced
;;
;; Contrato declarado con la API pública de la biblioteca: los records, sus
;; constructores y sus accesores quedan internos y solo se exportan las
;; operaciones de la especificación.
;;
;; Adaptaciones declaradas:
;; - Variante inmutable: cada actualización devuelve un valor nuevo y el
;;   original no cambia; `set_left`/`set_right` son `tree-node-with-left` y
;;   `tree-node-with-right`.
;; - Reutilización del valor por valor embebido: Scheme no hereda records, así
;;   que `<node>` (solo el valor, sin constructor exportado) vive dentro de
;;   `<tree-node>` y de `<graph-node>`, y cada hijo valida sus propios enlaces.
;; - Ausencia y fallo: `#f`. `graph-neighbors` devuelve `'()` para un vértice
;;   aislado y `#f` para un vértice inexistente, que es la distinción que exige
;;   la especificación.
;; - Registro enlazado canónico por `next-vertex`, escrito a mano: ni `assoc`
;;   ni `member` se usan para buscar o insertar en la adyacencia.

(define-library (data_structures_advanced)
  (export make-tree-node
          tree-node-value
          tree-node-left
          tree-node-right
          tree-node-with-left
          tree-node-with-right
          make-binary-tree
          binary-tree-insert
          binary-tree-contains?
          binary-tree-empty?
          binary-tree-size
          make-graph
          graph-add-vertex
          graph-add-edge
          graph-has-edge?
          graph-neighbors
          graph-empty?
          graph-vertex-count
          graph-edge-count)
  (import (scheme base))
  (begin
    ;; Base local del módulo: solo el valor. Sin enlaces, sin validaciones y
    ;; sin constructor exportado, así que no se instancia por sí sola.
    (define-record-type <node>
      (%make-node value)
      node?
      (value %node-value))

    (define-record-type <tree-node>
      (%make-tree-node value left right)
      tree-node?
      (value %tree-node-value)
      (left %tree-node-left)
      (right %tree-node-right))

    (define-record-type <binary-tree>
      (%make-binary-tree root count)
      binary-tree?
      (root %binary-tree-root)
      (count %binary-tree-count))

    (define-record-type <graph-node>
      (%make-graph-node value neighbors next-vertex)
      graph-node?
      (value %graph-node-value)
      (neighbors %graph-node-neighbors)
      (next-vertex %graph-node-next-vertex))

    (define-record-type <graph>
      (%make-graph vertices vertex-count edge-count)
      graph?
      (vertices %graph-vertices)
      (vertex-count %graph-vertex-count)
      (edge-count %graph-edge-count))

    ;; TreeNode: valor embebido y dos enlaces que valida este nodo. Un enlace
    ;; ausente es #f y las actualizaciones devuelven un nodo nuevo.
    (define (make-tree-node value)
      (%make-tree-node (%make-node value) #f #f))

    (define (tree-node-value node)
      (%node-value (%tree-node-value node)))

    (define (tree-node-left node)
      (%tree-node-left node))

    (define (tree-node-right node)
      (%tree-node-right node))

    (define (tree-node-with-left node left)
      (%make-tree-node (%tree-node-value node) left (%tree-node-right node)))

    (define (tree-node-with-right node right)
      (%make-tree-node (%tree-node-value node) (%tree-node-left node) right))

    ;; BinaryTree: ABB sin capacidad contractual. `insert` devuelve el árbol
    ;; nuevo (también con un duplicado, que no crece el tamaño) y nunca falla.
    (define (make-binary-tree)
      (%make-binary-tree #f 0))

    (define (binary-tree-insert tree value)
      (define (insert-node node)
        (cond
          ((not node)
           (values (make-tree-node value) #t))
          ((= value (tree-node-value node))
           (values node #f))
          ((< value (tree-node-value node))
           (let-values (((new-left inserted?) (insert-node (tree-node-left node))))
             (values (tree-node-with-left node new-left) inserted?)))
          (else
           (let-values (((new-right inserted?) (insert-node (tree-node-right node))))
             (values (tree-node-with-right node new-right) inserted?)))))
      (let-values (((root inserted?) (insert-node (%binary-tree-root tree))))
        (%make-binary-tree
         root
         (if inserted?
             (+ (%binary-tree-count tree) 1)
             (%binary-tree-count tree)))))

    ;; Descenso por la invariante del ABB, escrito a mano.
    (define (binary-tree-contains? tree value)
      (define (contains-node? node)
        (cond
          ((not node) #f)
          ((= value (tree-node-value node)) #t)
          ((< value (tree-node-value node))
           (contains-node? (tree-node-left node)))
          (else
           (contains-node? (tree-node-right node)))))
      (contains-node? (%binary-tree-root tree)))

    (define (binary-tree-empty? tree)
      (= (%binary-tree-count tree) 0))

    (define (binary-tree-size tree)
      (%binary-tree-count tree))

    ;; GraphNode: vértice interno. Valor por embebido, vecinos en orden
    ;; creciente sin duplicados y enlace al siguiente vértice del registro.
    (define (make-graph-node label)
      (%make-graph-node (%make-node label) '() #f))

    (define (graph-node-value node)
      (%node-value (%graph-node-value node)))

    (define (graph-node-neighbors node)
      (%graph-node-neighbors node))

    (define (graph-node-next node)
      (%graph-node-next-vertex node))

    ;; Búsqueda lineal por etiqueta sobre el registro enlazado.
    (define (find-vertex vertex label)
      (cond
        ((not vertex) #f)
        ((= label (graph-node-value vertex)) vertex)
        (else (find-vertex (graph-node-next vertex) label))))

    ;; Recorrido manual de la adyacencia: sin `member` ni `assoc`.
    (define (has-label? label labels)
      (cond
        ((null? labels) #f)
        ((= label (car labels)) #t)
        (else (has-label? label (cdr labels)))))

    ;; Inserción ordenada manual, sin duplicar el valor.
    (define (insert-label label labels)
      (cond
        ((null? labels) (list label))
        ((< label (car labels)) (cons label labels))
        (else (cons (car labels) (insert-label label (cdr labels))))))

    ;; Reconstruye el registro con la adyacencia nueva de un solo vértice.
    (define (update-neighbors vertex label new-neighbors)
      (cond
        ((not vertex) #f)
        ((= label (graph-node-value vertex))
         (%make-graph-node (%graph-node-value vertex)
                           new-neighbors
                           (graph-node-next vertex)))
        (else
         (%make-graph-node (%graph-node-value vertex)
                           (graph-node-neighbors vertex)
                           (update-neighbors (graph-node-next vertex)
                                             label
                                             new-neighbors)))))

    ;; Graph: registro canónico enlazado y contadores separados.
    (define (make-graph)
      (%make-graph #f 0 0))

    (define (graph-node-with-next label next)
      (%make-graph-node (%make-node label) '() next))

    (define (graph-add-vertex graph label)
      (if (find-vertex (%graph-vertices graph) label)
          graph
          (%make-graph (graph-node-with-next label (%graph-vertices graph))
                       (+ (%graph-vertex-count graph) 1)
                       (%graph-edge-count graph))))

    (define (graph-add-edge graph source target)
      (let ((source-vertex (find-vertex (%graph-vertices graph) source))
            (target-vertex (find-vertex (%graph-vertices graph) target)))
        (cond
          ((not source-vertex) #f)
          ((not target-vertex) #f)
          ((has-label? target (graph-node-neighbors source-vertex)) graph)
          (else
           (%make-graph
            (update-neighbors (%graph-vertices graph)
                              source
                              (insert-label target
                                            (graph-node-neighbors
                                             source-vertex)))
            (%graph-vertex-count graph)
            (+ (%graph-edge-count graph) 1))))))

    (define (graph-has-edge? graph source target)
      (let ((source-vertex (find-vertex (%graph-vertices graph) source)))
        (and source-vertex
             (has-label? target (graph-node-neighbors source-vertex)))))

    (define (graph-neighbors graph label)
      (let ((vertex (find-vertex (%graph-vertices graph) label)))
        (if vertex
            (graph-node-neighbors vertex)
            #f)))

    (define (graph-empty? graph)
      (= (%graph-vertex-count graph) 0))

    (define (graph-vertex-count graph)
      (%graph-vertex-count graph))

    (define (graph-edge-count graph)
      (%graph-edge-count graph))))
