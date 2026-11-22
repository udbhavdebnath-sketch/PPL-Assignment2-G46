; Append this file after code/46_q3.rkt; no language or import declarations.
; Atom comparisons use eq? only for symbols and the small exact integers in these tests.
; Empty lists match; pairs match recursively; a pair cannot match an atom.
(define (my-s1-same? actual expected)
  (cond ((null? actual) (null? expected))
        ((null? expected) #f)
        ((pair? actual)
         (and (pair? expected)
              (my-s1-same? (car actual) (car expected))
              (my-s1-same? (cdr actual) (cdr expected))))
        ((pair? expected) #f)
        (else (eq? actual expected))))

; Display the comparison status and test name as a two-element list.
(define (my-s1-check name actual expected)
  (display (list (if (my-s1-same? actual expected) 'PASS 'FAIL) name))
  (newline))

; Fixtures and expected values below are specified manually.
(define s1-t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define s1-t2 '(1 () (2 () (3 () ()))))
(define s1-t3 '(a (b () ()) (c () ())))
(define s1-empty '())
(define s1-single '(9 () ()))
(define s1-left-chain '(3 (2 (1 () ()) ()) ()))
(define s1-right-chain '(a () (b () (c () (d () ())))))
(define s1-asymmetric '(4 (2 () (3 () ())) (7 (6 (5 () ()) ()) ())))
(define s1-repeated '(2 (2 () ()) (2 (2 () ()) ())))

; my-append: ordinary, empty, and nested-list cases.
(my-s1-check 'append-normal (my-append '(1 2) '(3 4)) '(1 2 3 4))
(my-s1-check 'append-left-empty (my-append '() '(a b)) '(a b))
(my-s1-check 'append-right-empty (my-append '(1 2) '()) '(1 2))
(my-s1-check 'append-both-empty (my-append '() '()) '())
(my-s1-check 'append-nested (my-append '((1) a) '(() b)) '((1) a () b))

; Value checks for t1.
(my-s1-check 't1-inorder (inorder-values s1-t1) '(1 2 3 4 5 6 7))
(my-s1-check 't1-preorder (preorder-values s1-t1) '(4 2 1 3 6 5 7))
(my-s1-check 't1-postorder (postorder-values s1-t1) '(1 3 2 5 7 6 4))
(my-s1-check 't1-height (tree-height s1-t1) 3)
(my-s1-check 't1-leaves (leaf-count s1-t1) 4)

; Value checks for t2.
(my-s1-check 't2-inorder (inorder-values s1-t2) '(1 2 3))
(my-s1-check 't2-preorder (preorder-values s1-t2) '(1 2 3))
(my-s1-check 't2-postorder (postorder-values s1-t2) '(3 2 1))
(my-s1-check 't2-height (tree-height s1-t2) 3)
(my-s1-check 't2-leaves (leaf-count s1-t2) 1)

; Value checks for t3.
(my-s1-check 't3-inorder (inorder-values s1-t3) '(b a c))
(my-s1-check 't3-preorder (preorder-values s1-t3) '(a b c))
(my-s1-check 't3-postorder (postorder-values s1-t3) '(b c a))
(my-s1-check 't3-height (tree-height s1-t3) 2)
(my-s1-check 't3-leaves (leaf-count s1-t3) 2)

; Value checks for empty.
(my-s1-check 'empty-inorder (inorder-values s1-empty) '())
(my-s1-check 'empty-preorder (preorder-values s1-empty) '())
(my-s1-check 'empty-postorder (postorder-values s1-empty) '())
(my-s1-check 'empty-height (tree-height s1-empty) 0)
(my-s1-check 'empty-leaves (leaf-count s1-empty) 0)

; Value checks for single.
(my-s1-check 'single-inorder (inorder-values s1-single) '(9))
(my-s1-check 'single-preorder (preorder-values s1-single) '(9))
(my-s1-check 'single-postorder (postorder-values s1-single) '(9))
(my-s1-check 'single-height (tree-height s1-single) 1)
(my-s1-check 'single-leaves (leaf-count s1-single) 1)

; Value checks for left-chain.
(my-s1-check 'left-chain-inorder (inorder-values s1-left-chain) '(1 2 3))
(my-s1-check 'left-chain-preorder (preorder-values s1-left-chain) '(3 2 1))
(my-s1-check 'left-chain-postorder (postorder-values s1-left-chain) '(1 2 3))
(my-s1-check 'left-chain-height (tree-height s1-left-chain) 3)
(my-s1-check 'left-chain-leaves (leaf-count s1-left-chain) 1)

; Value checks for right-chain.
(my-s1-check 'right-chain-inorder (inorder-values s1-right-chain) '(a b c d))
(my-s1-check 'right-chain-preorder (preorder-values s1-right-chain) '(a b c d))
(my-s1-check 'right-chain-postorder (postorder-values s1-right-chain) '(d c b a))
(my-s1-check 'right-chain-height (tree-height s1-right-chain) 4)
(my-s1-check 'right-chain-leaves (leaf-count s1-right-chain) 1)

; Value checks for asymmetric.
(my-s1-check 'asymmetric-inorder (inorder-values s1-asymmetric) '(2 3 4 5 6 7))
(my-s1-check 'asymmetric-preorder (preorder-values s1-asymmetric) '(4 2 3 7 6 5))
(my-s1-check 'asymmetric-postorder (postorder-values s1-asymmetric) '(3 2 5 6 7 4))
(my-s1-check 'asymmetric-height (tree-height s1-asymmetric) 4)
(my-s1-check 'asymmetric-leaves (leaf-count s1-asymmetric) 2)

; Value checks for repeated.
(my-s1-check 'repeated-inorder (inorder-values s1-repeated) '(2 2 2 2))
(my-s1-check 'repeated-preorder (preorder-values s1-repeated) '(2 2 2 2))
(my-s1-check 'repeated-postorder (postorder-values s1-repeated) '(2 2 2 2))
(my-s1-check 'repeated-height (tree-height s1-repeated) 3)
(my-s1-check 'repeated-leaves (leaf-count s1-repeated) 2)

; Printing checks are visual: labels occupy separate lines, outside checked output.
; Compare each following block with its exact expected output comments.

(display 't1-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 2 3 4 5 6 7)
(print-inorder s1-t1)

(display 't1-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 2 3 4 5 6 7)
; (4 2 1 3 6 5 7)
; (1 3 2 5 7 6 4)
(print-all-traversals s1-t1)

(display 't1-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (3 4)
(print-height-and-leaves s1-t1)

(display 't2-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 2 3)
(print-inorder s1-t2)

(display 't2-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 2 3)
; (1 2 3)
; (3 2 1)
(print-all-traversals s1-t2)

(display 't2-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (3 1)
(print-height-and-leaves s1-t2)

(display 't3-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (b a c)
(print-inorder s1-t3)

(display 't3-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (b a c)
; (a b c)
; (b c a)
(print-all-traversals s1-t3)

(display 't3-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (2 2)
(print-height-and-leaves s1-t3)

(display 'empty-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; ()
(print-inorder s1-empty)

(display 'empty-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; ()
; ()
; ()
(print-all-traversals s1-empty)

(display 'empty-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (0 0)
(print-height-and-leaves s1-empty)

(display 'single-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (9)
(print-inorder s1-single)

(display 'single-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (9)
; (9)
; (9)
(print-all-traversals s1-single)

(display 'single-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 1)
(print-height-and-leaves s1-single)

(display 'left-chain-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 2 3)
(print-inorder s1-left-chain)

(display 'left-chain-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (1 2 3)
; (3 2 1)
; (1 2 3)
(print-all-traversals s1-left-chain)

(display 'left-chain-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (3 1)
(print-height-and-leaves s1-left-chain)

(display 'right-chain-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (a b c d)
(print-inorder s1-right-chain)

(display 'right-chain-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (a b c d)
; (a b c d)
; (d c b a)
(print-all-traversals s1-right-chain)

(display 'right-chain-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (4 1)
(print-height-and-leaves s1-right-chain)

(display 'asymmetric-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (2 3 4 5 6 7)
(print-inorder s1-asymmetric)

(display 'asymmetric-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (2 3 4 5 6 7)
; (4 2 3 7 6 5)
; (3 2 5 6 7 4)
(print-all-traversals s1-asymmetric)

(display 'asymmetric-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (4 2)
(print-height-and-leaves s1-asymmetric)

(display 'repeated-print-inorder)
(newline)
; Expected output from the next call (each line ends with one newline):
; (2 2 2 2)
(print-inorder s1-repeated)

(display 'repeated-print-all-traversals)
(newline)
; Expected output from the next call (each line ends with one newline):
; (2 2 2 2)
; (2 2 2 2)
; (2 2 2 2)
(print-all-traversals s1-repeated)

(display 'repeated-print-height-and-leaves)
(newline)
; Expected output from the next call (each line ends with one newline):
; (3 2)
(print-height-and-leaves s1-repeated)

