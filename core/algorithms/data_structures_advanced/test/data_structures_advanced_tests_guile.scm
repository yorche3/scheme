;; Casos de prueba de la especificación 07_Data_Structures_Advanced.md — GNU Guile + SRFI-64.
;;
;; Contrato: todo inmutable; cada actualización devuelve un valor nuevo (o #f si
;; falla), así que los escenarios se encadenan con `let*` y no hay estado
;; compartido. `(make-binary-tree)` y `(make-graph)` son el `init()`.
;; Éxito = valor distinto de #f; fallo = #f. `binary-tree-contains?` y
;; `graph-has-edge?` devuelven booleanos; `graph-neighbors` devuelve una lista
;; (incluida '() para un vértice aislado) o #f si el vértice no existe.
;; Los enlaces ausentes de un TreeNode son #f.
;;
;; Adaptaciones: `get_value(get_left())` se escribe como
;; `(tree-node-value (tree-node-left padre))`; `set_left`/`set_right` son
;; `tree-node-with-left`/`-right`. «Aislamiento del resultado de vecinos»: las
;; listas son inmutables por convención y no se modifica ninguna copia; se
;; comprueba que el resultado guardado no cambia tras la nueva arista.
;; Los grupos siguen el orden de la especificación: TreeNode, BinaryTree, Graph.

(use-modules (srfi srfi-64))
(load "../src/data_structures_advanced.scm")
(use-modules (data_structures_advanced))

;; Convierte "éxito = valor no #f" en un booleano comparable.
(define (success? value) (if value #t #f))

(define (check-success name value)
  (test-equal name #t (success? value)))

(test-begin "data_structures_advanced")

;; ---------------------------------------------------------------------------
;; TreeNode
;; ---------------------------------------------------------------------------

(test-group "TreeNode"
  (test-equal "TreeNode get_value should return the value given to init"
              10
              (tree-node-value (make-tree-node 10)))

  (let ((node (make-tree-node 10)))
    (test-equal "TreeNode get_left should be absent after init" #f (tree-node-left node))
    (test-equal "TreeNode get_right should be absent after init" #f (tree-node-right node)))

  (let* ((parent (tree-node-with-right
                  (tree-node-with-left (make-tree-node 10) (make-tree-node 20))
                  (make-tree-node 30))))
    (test-equal "TreeNode get_value of left child should be 20"
                20
                (tree-node-value (tree-node-left parent)))
    (test-equal "TreeNode get_value of right child should be 30"
                30
                (tree-node-value (tree-node-right parent)))
    (test-equal "TreeNode left child links should be absent"
                '(#f #f)
                (list (tree-node-left (tree-node-left parent))
                      (tree-node-right (tree-node-left parent))))
    (test-equal "TreeNode right child links should be absent"
                '(#f #f)
                (list (tree-node-left (tree-node-right parent))
                      (tree-node-right (tree-node-right parent)))))

  (let* ((linked (tree-node-with-right
                  (tree-node-with-left (make-tree-node 10) (make-tree-node 20))
                  (make-tree-node 30)))
         (no-left (tree-node-with-left linked #f))
         (no-links (tree-node-with-right no-left #f)))
    (test-equal "TreeNode clearing left should keep value 10"
                10 (tree-node-value no-left))
    (test-equal "TreeNode clearing left should remove the left link"
                #f (tree-node-left no-left))
    (test-equal "TreeNode clearing left should keep right child 30"
                30 (tree-node-value (tree-node-right no-left)))
    (test-equal "TreeNode clearing right should leave both links absent"
                '(#f #f)
                (list (tree-node-left no-links) (tree-node-right no-links)))
    (test-equal "TreeNode clearing right should keep value 10"
                10 (tree-node-value no-links)))

  (let* ((original (make-tree-node 10))
         (updated (tree-node-with-left original (make-tree-node 20))))
    (test-equal "TreeNode with-left should return a node carrying the new link"
                20 (tree-node-value (tree-node-left updated)))
    (test-equal "TreeNode with-left should leave the original unchanged"
                #f (tree-node-left original))))

;; ---------------------------------------------------------------------------
;; BinaryTree
;; ---------------------------------------------------------------------------

;; Inserta en orden comprobando el éxito de cada alta; devuelve el árbol final.
(define (insert-all name tree values)
  (let loop ((tree tree) (values values))
    (if (null? values)
        tree
        (let ((next (binary-tree-insert tree (car values))))
          (check-success
           (string-append name " should succeed inserting "
                          (number->string (car values)))
           next)
          (loop next (cdr values))))))

(define (check-members name tree values)
  (for-each
   (lambda (value)
     (test-equal (string-append name " should contain " (number->string value))
                 #t (binary-tree-contains? tree value)))
   values))

(test-group "BinaryTree"
  (let ((tree (make-binary-tree)))
    (test-equal "BinaryTree create empty should be empty" #t (binary-tree-empty? tree))
    (test-equal "BinaryTree create empty should have size 0" 0 (binary-tree-size tree))
    (test-equal "BinaryTree create empty should not contain 50"
                #f (binary-tree-contains? tree 50)))

  (let ((tree (binary-tree-insert (make-binary-tree) 50)))
    (check-success "BinaryTree insert root should succeed" tree)
    (test-equal "BinaryTree insert root should give size 1" 1 (binary-tree-size tree))
    (test-equal "BinaryTree insert root should not be empty" #f (binary-tree-empty? tree))
    (test-equal "BinaryTree insert root should contain 50"
                #t (binary-tree-contains? tree 50)))

  (let ((tree (insert-all "BinaryTree lower and higher" (make-binary-tree) '(50 30 70))))
    (test-equal "BinaryTree lower and higher should give size 3" 3 (binary-tree-size tree))
    (check-members "BinaryTree lower and higher" tree '(50 30 70)))

  (let ((tree (insert-all "BinaryTree multilevel" (make-binary-tree) '(50 30 70 20 40))))
    (check-members "BinaryTree multilevel" tree '(50 30 70 20 40))
    (test-equal "BinaryTree multilevel should give size 5" 5 (binary-tree-size tree)))

  (let ((tree (binary-tree-insert (make-binary-tree) 50)))
    (test-equal "BinaryTree missing value should not be found"
                #f (binary-tree-contains? tree 99))
    (test-equal "BinaryTree missing value should keep size 1" 1 (binary-tree-size tree))
    (test-equal "BinaryTree missing value should keep 50 present"
                #t (binary-tree-contains? tree 50)))

  (let ((tree (insert-all "BinaryTree duplicate" (make-binary-tree) '(50 30 70 30))))
    (test-equal "BinaryTree duplicate should keep size 3" 3 (binary-tree-size tree))
    (check-members "BinaryTree duplicate" tree '(50 30 70)))

  (let ((tree (insert-all "BinaryTree ordered" (make-binary-tree) '(20 30 40 50 70))))
    (test-equal "BinaryTree ordered should give size 5" 5 (binary-tree-size tree))
    (check-members "BinaryTree ordered" tree '(20 30 40 50 70))
    (test-equal "BinaryTree ordered should not contain 99"
                #f (binary-tree-contains? tree 99))))

;; ---------------------------------------------------------------------------
;; Graph
;; ---------------------------------------------------------------------------

(define (vertices-of name graph labels)
  (let loop ((graph graph) (labels labels))
    (if (null? labels)
        graph
        (let ((next (graph-add-vertex graph (car labels))))
          (check-success
           (string-append name " should succeed registering "
                          (number->string (car labels)))
           next)
          (loop next (cdr labels))))))

(define (edges-of name graph edges)
  (let loop ((graph graph) (edges edges))
    (if (null? edges)
        graph
        (let ((next (graph-add-edge graph (caar edges) (cdar edges))))
          (check-success
           (string-append name " should succeed adding edge "
                          (number->string (caar edges)) "->"
                          (number->string (cdar edges)))
           next)
          (loop next (cdr edges))))))

(define (check-counts name graph vertices edges)
  (test-equal (string-append name " should have " (number->string vertices) " vertices")
              vertices (graph-vertex-count graph))
  (test-equal (string-append name " should have " (number->string edges) " edges")
              edges (graph-edge-count graph)))

(test-group "Graph"
  (let ((graph (make-graph)))
    (test-equal "Graph create empty should be empty" #t (graph-empty? graph))
    (check-counts "Graph create empty" graph 0 0)
    (test-equal "Graph create empty should not have edge 10->30"
                #f (graph-has-edge? graph 10 30))
    (test-equal "Graph create empty should fail neighbours of 10"
                #f (graph-neighbors graph 10)))

  (let ((graph (graph-add-vertex (make-graph) 10)))
    (check-success "Graph isolated vertex should succeed" graph)
    (test-equal "Graph isolated vertex should not be empty" #f (graph-empty? graph))
    (check-counts "Graph isolated vertex" graph 1 0)
    (test-equal "Graph isolated vertex should have empty neighbours of 10"
                '() (graph-neighbors graph 10)))

  (let ((graph (edges-of "Graph directed edge"
                         (vertices-of "Graph directed edge" (make-graph) '(10 70))
                         '((10 . 70)))))
    (test-equal "Graph directed edge should have forward edge 10->70"
                #t (graph-has-edge? graph 10 70))
    (test-equal "Graph directed edge should not have reverse edge 70->10"
                #f (graph-has-edge? graph 70 10))
    (check-counts "Graph directed edge" graph 2 1))

  (let* ((base (edges-of "Graph duplicate vertex"
                         (vertices-of "Graph duplicate vertex" (make-graph) '(10 30))
                         '((10 . 30))))
         (graph (graph-add-vertex base 10)))
    (check-success "Graph duplicate vertex should succeed" graph)
    (check-counts "Graph duplicate vertex" graph 2 1)
    (test-equal "Graph duplicate vertex should preserve neighbours of 10"
                '(30) (graph-neighbors graph 10)))

  (let ((graph (edges-of "Graph duplicate edge"
                         (vertices-of "Graph duplicate edge" (make-graph) '(10 30))
                         '((10 . 30) (10 . 30)))))
    (check-counts "Graph duplicate edge" graph 2 1)
    (test-equal "Graph duplicate edge should keep neighbours of 10 as (30)"
                '(30) (graph-neighbors graph 10)))

  (let ((graph (edges-of "Graph missing endpoint"
                         (vertices-of "Graph missing endpoint" (make-graph) '(10 30))
                         '((10 . 30)))))
    (for-each
     (lambda (edge)
       (test-equal (string-append "Graph missing endpoint should fail edge "
                                  (number->string (car edge)) "->"
                                  (number->string (cdr edge)))
                   #f (graph-add-edge graph (car edge) (cdr edge))))
     '((10 . 99) (99 . 10) (98 . 99) (99 . 99)))
    (check-counts "Graph missing endpoint" graph 2 1)
    (test-equal "Graph missing endpoint should preserve neighbours of 10"
                '(30) (graph-neighbors graph 10))
    (test-equal "Graph missing endpoint should keep neighbours of 30 empty"
                '() (graph-neighbors graph 30))
    (for-each
     (lambda (edge)
       (test-equal (string-append "Graph missing endpoint should not have edge "
                                  (number->string (car edge)) "->"
                                  (number->string (cdr edge)))
                   #f (graph-has-edge? graph (car edge) (cdr edge))))
     '((10 . 99) (99 . 10) (98 . 99) (99 . 99)))
    (test-equal "Graph missing endpoint should fail neighbours of 98"
                #f (graph-neighbors graph 98))
    (test-equal "Graph missing endpoint should fail neighbours of 99"
                #f (graph-neighbors graph 99)))

  (let ((graph (edges-of "Graph sorted neighbours"
                         (vertices-of "Graph sorted neighbours" (make-graph) '(10 30 50 70))
                         '((10 . 70) (10 . 30) (10 . 50) (30 . 50)))))
    (test-equal "Graph sorted neighbours should list 10 as (30 50 70)"
                '(30 50 70) (graph-neighbors graph 10))
    (test-equal "Graph sorted neighbours should list 30 as (50)"
                '(50) (graph-neighbors graph 30))
    (test-equal "Graph sorted neighbours should list 50 as empty"
                '() (graph-neighbors graph 50))
    (test-equal "Graph sorted neighbours should list 70 as empty"
                '() (graph-neighbors graph 70))
    (check-counts "Graph sorted neighbours" graph 4 4))

  (let ((graph (vertices-of "Graph missing-edge query" (make-graph) '(10 30))))
    (test-equal "Graph missing-edge query should fail for 10->30"
                #f (graph-has-edge? graph 10 30))
    (check-counts "Graph missing-edge query" graph 2 0)
    (test-equal "Graph missing-edge query should not be empty" #f (graph-empty? graph)))

  (let ((graph (graph-add-vertex (make-graph) 10)))
    (test-equal "Graph neighbours of missing vertex should fail"
                #f (graph-neighbors graph 99))
    (test-equal "Graph neighbours of missing vertex should differ from empty neighbours"
                #t (not (equal? (graph-neighbors graph 99) (graph-neighbors graph 10))))
    (check-counts "Graph neighbours of missing vertex" graph 1 0))

  (let ((graph (edges-of "Graph self-loop"
                         (graph-add-vertex (make-graph) 10)
                         '((10 . 10) (10 . 10)))))
    (test-equal "Graph self-loop should have edge 10->10"
                #t (graph-has-edge? graph 10 10))
    (test-equal "Graph self-loop should list neighbours (10)"
                '(10) (graph-neighbors graph 10))
    (check-counts "Graph self-loop" graph 1 1))

  (let* ((base (edges-of "Graph neighbour isolation"
                         (vertices-of "Graph neighbour isolation" (make-graph) '(10 30 50))
                         '((10 . 30))))
         (saved (graph-neighbors base 10))
         (graph (graph-add-edge base 10 50)))
    (check-success "Graph neighbour isolation should succeed adding 10->50" graph)
    (test-equal "Graph neighbour isolation should keep the saved result (30)"
                '(30) saved)
    (test-equal "Graph neighbour isolation should give fresh neighbours (30 50)"
                '(30 50) (graph-neighbors graph 10))
    (check-counts "Graph neighbour isolation" graph 3 2)))

(test-end "data_structures_advanced")
