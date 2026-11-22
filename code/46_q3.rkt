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
