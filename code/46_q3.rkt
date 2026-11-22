#lang racket/base

; Appending () to ys gives ys; otherwise keep the first element and append the rest to ys.
(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

; Inorder of () is (); otherwise join the left subtree's values, the node, and the right subtree's values.
(define (inorder-values tree)
  (if (null? tree)
      '()
      (my-append (inorder-values (cadr tree))
                 (cons (car tree) (inorder-values (caddr tree))))))

; Preorder of () is (); otherwise place the node before the left and right subtree values.
(define (preorder-values tree)
  (if (null? tree)
      '()
      (cons (car tree)
            (my-append (preorder-values (cadr tree))
                       (preorder-values (caddr tree))))))

; Postorder of () is (); otherwise join the left subtree's values, the right subtree's values, then the node.
(define (postorder-values tree)
  (if (null? tree)
      '()
      (my-append (postorder-values (cadr tree))
                 (my-append (postorder-values (caddr tree))
                            (list (car tree))))))

; Height of () is 0; otherwise it is 1 plus the larger of the left and right subtree heights.
(define (tree-height tree)
  (if (null? tree)
      0
      (let* ((left-height (tree-height (cadr tree)))
             (right-height (tree-height (caddr tree))))
        (+ 1 (max left-height right-height)))))

; Empty trees have 0 leaves; a node with two empty subtrees has 1; otherwise sum the subtree leaf counts.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (cadr tree)) (null? (caddr tree))) 1)
        (else
         (let* ((left-count (leaf-count (cadr tree)))
                (right-count (leaf-count (caddr tree))))
           (+ left-count right-count)))))
