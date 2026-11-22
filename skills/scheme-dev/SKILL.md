---
name: scheme-dev
description: Rules and checklist for writing Racket (Scheme) code for CS F301 Assignment 2, problems S1 and S2.
---

# Scheme development skill (CS F301 Assignment 2)

## Language and version
- Racket 8.x. Every solution file starts with `#lang racket/base`; appended test-call files have no language line.
- Solution files contain ONLY definitions. No top-level calls, nothing printed on load, no `provide`.
- The grader runs `racket 46_q3.rkt` / `racket 46_q4.rkt` and appends its own calls to the end of the file.

## Allowed built-ins (nothing else)
define, lambda, let, let*, letrec, named let, if, cond (with else), and, or, not, begin,
quote ('), cons, car, cdr, list, all car/cdr compositions up to 4 levels (cadr, cddr, caddr, cdddr, cadddr, cddddr, ...),
null?, pair?, eq?, assq, assoc, + - * < > <= >= =, max, display, newline.
S2 additionally allows: read.

## Forbidden (write your own helper instead)
set! and relatives, vectors, hash tables, strings (no "..." anywhere), loops (do, for),
length, append, reverse, map, filter, member, memq, list-ref, list-tail,
list?, symbol?, number?, equal?, printf, format, provide.
For the guaranteed proper-list-or-atom inputs of S2, use (or (null? e) (pair? e))
to distinguish a list from an atom. This is not a general proper-list predicate: it also accepts dotted pairs.
For output labels use symbols (e.g. 'PASS), never strings.

## Coding conventions
- kebab-case names; own helpers are prefixed my- (my-length, my-map, my-reverse, my-equal?).
- Above each function: a one-line comment with its recursive reading, e.g.
  ; length of () is 0; length of (a . rest) is 1 + length of rest
- Pass all state through arguments. Prefer tail recursion with an accumulator (named let) where natural; preserve traversal order.
- One prompt = one function, one test file or one review. Never write the whole problem at once.
- Record prompts word for word in the corresponding prompts file, and keep commits incremental by unit of work. For a review-only request, review and correct only the requested artifact; do not generate solution code.

## Repo layout
Paths are relative to the Group 46 repository root:
- S1: code/46_q3.rkt, tests/S1_calls.rkt, prompts/S1.md.
- S2: code/46_q4.rkt, tests/S2_calls.rkt, prompts/S2.md.
- Shared skill: skills/scheme-dev/SKILL.md.

## S1: Binary Tree Traversals
- A tree is () or a three-element list (value left right). Values are numbers or single-character symbols. The grader defines the trees and calls the functions.
- `print-inorder` takes one tree and displays one list in left-node-right order, followed by a newline.
- `print-all-traversals` takes one tree and displays exactly three lists on separate lines: inorder (left-node-right), preorder (node-left-right), then postorder (left-right-node). End each line with a newline. Visit left subtrees before right subtrees.
- `print-height-and-leaves` takes one tree and displays the list (height leaf-count), followed by a newline.
- Height counts nodes: empty tree = 0; singleton = 1; a node = 1 plus the maximum of its subtree heights.
- A leaf has both subtrees empty. The empty tree has 0 leaves; a singleton has 1. A node with only one child is not a leaf.
- Display lists with `display`; do not add labels, quotes, debug text, or extra lines. An empty tree gives () for every traversal and (0 0) for height/leaves.
- Test all PDF examples (t1, right-skewed t2, symbol-valued t3, empty tree), plus singleton, left-skewed and asymmetric trees. Check every traversal's order and exact output, not just its set of values.
- PDF reference outputs: t1 traversals are (1 2 3 4 5 6 7), (4 2 1 3 6 5 7), (1 3 2 5 7 6 4), with (3 4); t2 gives (1 2 3), (1 2 3), (3 2 1), with (3 1); t3 gives (b a c), (a b c), (b c a), with (2 2).

## S2: Conditionally Insert into a Nested List
- Preserve `my-length` and `my-map`, implemented with only allowed built-ins.
- `insert-if-short` takes x, lst and n. Insert the atom x at the front of every list whose original top-level length is strictly less than n, including the outer list and empty lists. Count a sublist as one element; do not count recursively or measure after insertion.
- Inputs contain atoms (digits or symbols) and proper lists, never dotted pairs; x is any atom and n is an integer >= 0. With n = 0, no list qualifies; () becomes (x) only when n > 0.
- `make-inserter` takes x and len-ok? and returns a one-argument list transformer. Apply len-ok? to each original list's length at every level, using the custom helpers. Do not revisit inserted elements.
- Develop S2.b using the custom helpers, then S2.c using `make-inserter`. The final file must have exactly one definition of `insert-if-short`, using `make-inserter`.
- `print-insert-result` takes no arguments, reads x, lst and n in that order, and displays only the resulting list followed by a newline. No input prompts.
- Test all four PDF examples, n = 0, length exactly n, empty outer and inner lists, mixed atoms/sublists, a custom len-ok? predicate, lists of 10,000 elements and nesting depth 100 (the PDF's S2 hidden-test sizes).

## How to run and test
Run from the repository root with Racket 8.x on PATH. Keep test fixtures and top-level calls in tests, never in solution files. Test-call files have no `#lang` or `require` line and are appended to a temporary copy of the solution. Avoid duplicate helper names across the combined file.

### Windows PowerShell (5.1 or newer)
Load checks must exit successfully and print nothing:
```powershell
racket .\code\46_q3.rkt
racket .\code\46_q4.rkt
```

Run S1 tests without modifying the submission file:
```powershell
$s1Run = Join-Path ([System.IO.Path]::GetTempPath()) ('g46-s1-' + [guid]::NewGuid().ToString() + '.rkt')
try {
    Get-Content -LiteralPath '.\code\46_q3.rkt', '.\tests\S1_calls.rkt' |
        Set-Content -LiteralPath $s1Run -Encoding UTF8
    racket $s1Run
    if ($LASTEXITCODE -ne 0) { throw 'S1 test execution failed' }
} finally {
    Remove-Item -LiteralPath $s1Run -ErrorAction SilentlyContinue
}
```
For S2, use the same procedure with `46_q4.rkt`, `S2_calls.rkt` and a `g46-s2-` temporary filename. A successful exit alone does not prove correctness: compare the printed lists and line breaks against expected results and inspect any FAIL reports.

S2 standard-input smoke test (the call exists only in the temporary file):
```powershell
$s2Run = Join-Path ([System.IO.Path]::GetTempPath()) ('g46-s2-input-' + [guid]::NewGuid().ToString() + '.rkt')
try {
    Get-Content -LiteralPath '.\code\46_q4.rkt' | Set-Content -LiteralPath $s2Run -Encoding UTF8
    Add-Content -LiteralPath $s2Run -Value '(print-insert-result)' -Encoding UTF8
    '42 ((1 2) (3 4 5) (6) ()) 3' | racket $s2Run
    if ($LASTEXITCODE -ne 0) { throw 'S2 input test execution failed' }
} finally {
    Remove-Item -LiteralPath $s2Run -ErrorAction SilentlyContinue
}
```
Expected output: `((42 1 2) (3 4 5) (42 6) (42))`, then a newline.
PowerShell strings above are shell syntax; they do not permit strings in Scheme source.

### Bash alternative (existing S2 workflow)
```bash
cat code/46_q4.rkt tests/S2_calls.rkt > /tmp/t.rkt && racket /tmp/t.rkt
(cat code/46_q4.rkt; echo "(print-insert-result)") > /tmp/p.rkt
echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket /tmp/p.rkt
```
These commands are for Bash, not Windows PowerShell.

## Common AI mistakes in Scheme
- Using prohibited convenience built-ins (append, reverse, map, length, equal?, list?, printf, etc.), mutation, loops, strings, extra imports, or `read` in S1. `list` is explicitly allowed; do not accidentally prohibit it.
- Confusing traversal orders, swapping left/right visits, printing the three traversals in the wrong sequence, or accidentally reversing output through accumulator construction.
- Counting height in edges (singleton 0) rather than nodes (singleton 1), counting empty subtrees as leaves, or treating a one-child node as a leaf.
- Leaving sample/test calls or debug displays at the top level, causing output when loaded; adding `provide`/`require` instead of using the grader's appended-call model.
- Applying car/cdr before handling (), constructing dotted pairs instead of proper lists, or using eq? as structural list equality. Use = for numeric comparison and custom recursive helpers where structural equality is needed.
- In S2, counting flattened or already-modified lists, using <= rather than <, skipping the outer or empty lists, revisiting inserted atoms, or retaining both versions of insert-if-short.
- Printing labels or input prompts, missing newlines, or claiming tests passed without executing them and checking expected output.

## Self-review checklist (apply before every answer)
Apply relevant items to the requested unit; mark others not applicable rather than expanding the work.
1. Only the exact allowed built-ins, including list? No forbidden helpers, imports, mutation, strings or loops? Is read confined to S2?
2. Solution starts with #lang racket/base and contains only definitions after it, with no top-level calls, prints or provide? Does the load check succeed silently?
3. Empty list handled before selectors? Proper tree/list structure maintained? S1 empty/singleton height and leaf conventions correct?
4. S2 handles 10,000-element lists and nesting depth 100? State passed through arguments and tail recursion used where natural without changing semantics?
5. Output uses display and newline, with exact list formatting, line count and ordering, no extra text? Helpers return values without unintended output?
6. Each function has a recursive-reading comment, clear kebab-case names, and custom helper names prefixed my- where the assignment does not prescribe another name?
7. S1 signatures match the PDF; inorder, preorder and postorder are correct and left-first; height counts nodes and only nodes with two empty children count as leaves?
8. S2 uses original top-level lengths, visits every list including empty and outer lists, and uses strict < n? my-length and my-map retained; make-inserter accepts a predicate; exactly one final insert-if-short uses make-inserter?
9. S2 input wrapper takes no arguments, reads x/lst/n in order, and prints no prompt?
10. Applicable PDF examples and independent edge cases checked, with expected output compared? Report which checks actually ran and any failures or unrun checks; do not claim execution from inspection alone.
11. Correct Group 46 code/test/prompt paths used, calls isolated in tests with no #lang, and solution files left free of test fixtures? Prompts retained verbatim in S1.md or S2.md and incremental commit history preserved?
12. Exactly one unit of work delivered for this prompt (one function, one test file or one review), preserving existing work for the other problem?
