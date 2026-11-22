---
name: scheme-dev
description: Rules and checklist for writing Racket (Scheme) code for CS F301 Assignment 2, problems S1 and S2.
---

# Scheme development skill (CS F301 Assignment 2)

## Language and version
- Racket 8.x. Every file starts with `#lang racket/base`.
- Files contain ONLY definitions. No top-level calls, nothing printed on load, no `provide`.
- Run with: `racket G17_q3.rkt` or `racket G17_q4.rkt` (the grader appends its own calls).

## Allowed built-ins (nothing else)
define, lambda, let, let*, letrec, named let, if, cond (with else), and, or, not, begin,
quote ('), cons, car, cdr, all car/cdr compositions up to 4 levels (cadr, cddr, caddr, ...),
null?, pair?, eq?, assq, assoc, + - * < > <= >= =, max, display, newline.
S2 additionally allows: read.

## Forbidden (write your own helper instead)
set! and relatives, vectors, hash tables, strings, loops (do, for),
length, append, reverse, map, filter, member, memq, list-ref, list-tail,
list?, symbol?, number?, printf, format.
To check whether something is a list, use (or (null? e) (pair? e)).

## Coding conventions
- kebab-case names; own helpers are prefixed my- (my-length, my-map, my-reverse).
- Above each function: a one-line comment with its recursive reading, e.g.
  ; length of () is 0; length of (a . rest) is 1 + length of rest
- Pass all state through arguments. Prefer tail recursion with an accumulator (named let).
- One prompt = one function. Never write the whole problem at once.

## How to test
- Put calls in a separate file (tests/S2_calls.rkt) with no #lang line, then run:
  cat G17/code/G17_q4.rkt G17/tests/S2_calls.rkt > /tmp/t.rkt && racket /tmp/t.rkt
- For functions that use read:
  echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket /tmp/p.rkt

## Self-review checklist (apply before every answer)
1. Only allowed built-ins are used? (scan for length, map, append, reverse, list?, set!)
2. File starts with #lang racket/base and has no top-level calls or prints?
3. Empty list () handled?
4. Works for 10,000-element lists and nesting depth 100 (tail recursion / accumulators)?
5. Output uses display and ends with newline, with no extra text?
6. Each function has its recursive-reading comment?
7. Checked against the examples given in the assignment?

## Known AI failure modes in Scheme
- Silently using forbidden built-ins: length, map, append, reverse, list?, filter.
- Writing #lang racket instead of #lang racket/base.
- Adding top-level test calls or printing in the solution file.
- Using printf or format instead of display.
- Using set! or mutation to keep state.
- Non-tail recursion that is slow or deep on large lists.
- Treating () as an atom, or mixing up length before vs after insertion.
- Inventing functions that do not exist in racket/base.