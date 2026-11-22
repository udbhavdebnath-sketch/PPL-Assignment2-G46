#lang racket/base

; length of () is 0; length of (a . rest) is 1 + length of rest
(define (my-length lst)
  (let loop ((rest lst) (acc 0))
    (if (null? rest)
        acc
        (loop (cdr rest) (+ acc 1)))))

; reverse of () is acc; reverse of (a . rest) is reverse of rest with a consed onto acc
(define (my-reverse lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc)))))

; map of () is (); map of (a . rest) is (f a) consed onto map of rest
(define (my-map f lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        (my-reverse acc)
        (loop (cdr rest) (cons (f (car rest)) acc)))))

; make-inserter returns a closure that captures x and len-ok?.
; Reading of the returned function: apply it to every sublist of lst (atoms stay
; as they are), then cons x onto the result if (len-ok? (original length of lst)) is true
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (e)
                               (if (or (null? e) (pair? e))
                                   (insert e)
                                   e))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert))

; insert-if-short is make-inserter with len-ok? true when the original length is less than n
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (k) (< k n))) lst))


; read x, then lst, then n from stdin (let* fixes the order),
; then display (insert-if-short x lst n) followed by a newline
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

