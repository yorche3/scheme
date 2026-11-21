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
    ;; Records use embedded values; their constructors and fields are internal.
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
      (%make-graph-node label neighbors next-vertex)
      graph-node?
      (label %graph-node-label)
      (neighbors %graph-node-neighbors)
      (next-vertex %graph-node-next-vertex))

    (define-record-type <graph>
      (%make-graph vertices vertex-count edge-count)
      graph?
      (vertices %graph-vertices)
      (vertex-count %graph-vertex-count)
      (edge-count %graph-edge-count))

    ;; Tree-node updates return a new node; absent links are #f.
    (define (make-tree-node value) #f)
    (define (tree-node-value node) #f)
    (define (tree-node-left node) #f)
    (define (tree-node-right node) #f)
    (define (tree-node-with-left node left) #f)
    (define (tree-node-with-right node right) #f)

    ;; Insert returns the new tree; predicates return booleans and size an integer.
    (define (make-binary-tree) #f)
    (define (binary-tree-insert tree value) #f)
    (define (binary-tree-contains? tree value) #f)
    (define (binary-tree-empty? tree) #f)
    (define (binary-tree-size tree) #f)

    ;; Graph-node construction is internal to the graph.
    (define (make-graph-node label) #f)

    ;; Updates return a new graph, or #f on failure. Neighbors returns a list
    ;; (including '() for an isolated vertex), or #f for a missing vertex.
    (define (make-graph) #f)
    (define (graph-add-vertex graph label) #f)
    (define (graph-add-edge graph source target) #f)
    (define (graph-has-edge? graph source target) #f)
    (define (graph-neighbors graph label) #f)
    (define (graph-empty? graph) #f)
    (define (graph-vertex-count graph) #f)
    (define (graph-edge-count graph) #f)))
