
; S2 tests: appended after code/46_q4.rkt, so no #lang line here.
 
; equal of two atoms is eq?; equal of two pairs is equal cars and equal cdrs
(define (my-equal? a b)
  (cond ((and (null? a) (null? b)) #t)
        ((and (pair? a) (pair? b))
         (and (my-equal? (car a) (car b))
              (my-equal? (cdr a) (cdr b))))
        ((or (pair? a) (pair? b) (null? a) (null? b)) #f)
        (else (eq? a b))))
 
; check displays PASS or FAIL, a space, then the test name, then a newline
(define (check name got expected)
  (display (if (my-equal? got expected) 'PASS 'FAIL))
  (display #\space)
  (display name)
  (newline))
 
; build a list of k copies of item (tail-recursive, for size tests)
(define (make-copies k item)
  (let loop ((i 0) (acc '()))
    (if (= i k)
        acc
        (loop (+ i 1) (cons item acc)))))
 
; wrap item in d levels of one-element lists (for the depth test)
(define (nest d item)
  (let loop ((i 0) (acc item))
    (if (= i d)
        acc
        (loop (+ i 1) (cons acc '())))))
 
; 1) Assignment examples
(check 'ex1 (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3)
       '((42 1 2) (3 4 5) (42 6) (42)))
(check 'ex2 (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3)
       '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))
(check 'ex3 (insert-if-short 7 '() 3)
       '(7))
(check 'ex4 (insert-if-short 7 '() 0)
       '())
 
; 2) Edge cases
(check 'n-zero (insert-if-short 'a '((1) (2 3) ()) 0)
       '((1) (2 3) ()))
(check 'large-n (insert-if-short 'a '((1) (2 (3))) 100)
       '(a (a 1) (a 2 (a 3))))
(check 'flat-short (insert-if-short 'a '(1 2 3) 5)
       '(a 1 2 3))
(check 'flat-not-short (insert-if-short 'a '(1 2 3) 3)
       '(1 2 3))
(check 'empty-inside (insert-if-short 'x '(()) 1)
       '((x)))
(check 'mixed (insert-if-short 'k '(a 1 (b 2) (c) d) 2)
       '(a 1 (b 2) (k c) d))
(check 'inserter-eq-2 ((make-inserter 'q (lambda (len) (= len 2))) '((1 2) (3) (4 (5 6)) 7))
       '((q 1 2) (3) (q 4 (q 5 6)) 7))
 
; 3) Size and depth (skill checklist item 4)
(check 'wide-10000 (my-length (insert-if-short 'z (make-copies 10000 '()) 1))
       10000)
(check 'wide-10000-inner (car (insert-if-short 'z (make-copies 10000 '()) 1))
       '(z))
(check 'deep-100 (insert-if-short 'z (nest 100 '()) 0)
       (nest 100 '()))
 
; 4) Stress tests
 
; numbers 1..k in order: range of 0 is (); range of k is range of k-1 with k at the end
(define (make-range k)
  (let loop ((i k) (acc '()))
    (if (= i 0)
        acc
        (loop (- i 1) (cons i acc)))))
 
; expected deep result: level 1 is (x item); level i is (x level-(i-1))
(define (nest-inserted d x item)
  (let loop ((i 1) (acc (cons x (cons item '()))))
    (if (= i d)
        acc
        (loop (+ i 1) (cons x (cons acc '()))))))
 
; 100 levels deep, (((...(1)...))), n = 2: every level has length 1, so every level gets x
(check 'stress-deep-100 (insert-if-short 'x (nest 100 1) 2)
       (nest-inserted 100 'x 1))
 
; flat 1..10000, n = 20000: only the top level is short, so x goes at the front once
(check 'stress-flat-10000 (insert-if-short 'x (make-range 10000) 20000)
       (cons 'x (make-range 10000)))