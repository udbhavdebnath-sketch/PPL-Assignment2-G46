#lang racket/base

; Appending () to ys gives ys; otherwise keep the first element and append the rest to ys.
(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))
