---
name: scheme-dev
description: Rules and checklist for writing Racket (Scheme) code for CS F301 Assignment 2, problems S1 and S2.
---

# Scheme development skill (CS F301 Assignment 2)

## Language and version
- Racket 8.x. Every file starts with `#lang racket/base`.
- Solution files contain ONLY definitions. No top-level calls, nothing printed on load, no `provide`.
- The grader runs `racket G17_q3.rkt` / `racket G17_q4.rkt` and appends its own calls to the end of the file.

## Allowed built-ins (nothing else)
define, lambda, let, let*, letrec, named let, if, cond (with else), and, or, not, begin,
quote ('), cons, car, cdr, all car/cdr compositions up to 4 levels (cadr, cddr, caddr, ...),
null?, pair?, eq?, assq, assoc, + - * < > <= >= =, max, display, newline.
S2 additionally allows: read.

## Forbidden (write your own helper instead)
set! and relatives, vectors, hash tables, strings (no "..." anywhere), loops (do, for),
length, append, reverse, map, filter, member, memq, list-ref, list-tail,
list?, symbol?, number?, equal?, printf, format, provide.
To check whether something is a list, use (or (null? e) (pair? e)).
For output labels use symbols (e.g. 'PASS), never strings.

## Coding conventions
- kebab-case names; own helpers are prefixed my- (my-length, my-map, my-reverse, my-equal?).
- Above each function: a one-line comment with its recursive reading, e.g.
  ; length of () is 0; length of (a . rest) is 1 + length of rest
- Pass all state through arguments. Prefer tail recursion with an accumulator (named let).
- One prompt = one function, one test file or one review. Never write the whole problem at once.

## Repo layout
code/G17_q4.rkt, tests/S2_calls.rkt, prompts/S2.md, skills/scheme-dev/SKILL.md

## How to run and test
- Load check (must print nothing):  racket code/G17_q4.rkt
- Tests (calls file has no #lang line):
  cat code/G17_q4.rkt tests/S2_calls.rkt > /tmp/t.rkt && racket /tmp/t.rkt
- Functions that use read:
  (cat code/G17_q4.rkt; echo "(print-insert-result)") > /tmp/p.rkt
  echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket /tmp/p.rkt

## Self-review checklist (apply before every answer)
1. Only allowed built-ins? (scan for length, map, append, reverse, list?, equal?, set!, strings)
2. File starts with #lang racket/base and has no top-level calls or prints?
3. Empty list () handled?
4. Works for 10,000-element lists and nesting depth 100 (tail recursion / accumulators)?
5. Output uses display, ends with newline, prints no extra text?
6. Each function has its recursive-reading comment?
7. Checked