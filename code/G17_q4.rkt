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



