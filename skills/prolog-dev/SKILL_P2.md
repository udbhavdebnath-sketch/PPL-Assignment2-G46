---
name: prolog-dev
description: Rules, conventions, test workflow, self-review checklist and known AI failure modes for writing SWI-Prolog 9.x code for CS F301 Assignment 2 (files id_q1.pl and id_q2.pl). Use this skill whenever writing, reviewing, debugging or testing any Prolog predicate for the assignment, especially P2 (valid arithmetic equations, generate_equation/2, all_equations/2, count_equations/2) and P1 (department puzzle), even if the request looks like a small one-predicate change.
---
 
# prolog-dev
 
## 1. Language, version, environment
 
- Language: **SWI-Prolog 9.x**. Do not use features from other Prologs (GNU, SICStus, Ciao).
- Allowed libraries only: `lists`, `apply`, `yall`, `aggregate`. No `assert`, `retract`, `b_setval`, `nb_setval`, no tabling/memoisation via the database.
- The file contains **only definitions**:
  - no `:- initialization(...)`, no `halt/0`, no top-level goals that run on load,
  - `:- use_module(library(...))` lines for allowed libraries are fine,
  - nothing printed on load, and **nothing printed by P2 predicates at all**.
- How the grader runs the code (our code must work under exactly this):
  - `swipl -q -f id_q2.pl -g "<goal>" -t halt`
  - `swipl -q -f id_q1.pl -g main -t halt` (P1 only)
- File names: replace `id` with the group ID (`id_q2.pl` for P2, `id_q1.pl` for P1).
## 2. Process rules (assignment ground rules the AI must respect)
 
- **Decomposition rule:** one prompt = one unit of work (one predicate, one test file, or one review). Never ask for / give the complete solution to a whole problem in one go. If asked to, refuse and offer to do the next single predicate.
- Work section by section and **commit after each unit** (e.g. "P2: add eval_div/4", "P2: add paren rule", "P2: all_equations/2"). The commit history must show this progression.
- Every prompt used is saved **word for word** in `prompts/P2.md` (or `P1.md`). Keep the log in this form:
  ```
  ## Prompt 1 - <unit, e.g. split/3>
  <exact prompt text>
  ```
- Collaboration only within the group. Never reuse another group's code, prompts or skill files.
- The student must be able to explain every line in the viva: prefer simple, readable code over clever code, and add a short comment per predicate.
## 3. Coding conventions
 
- Names: `snake_case` atoms/predicates; variables `CamelCase`; `_Unused` for intentionally unused variables, `_` for singletons.
- Every predicate gets a header comment in this style:
  ```prolog
  %% split(+List, -Left, -Right)
  %  Declarative reading: List is Left followed by Right, both non-empty.
  ```
- Give each predicate a **declarative reading** (what it means as a relation) and, where recursive, a **recursive reading** (base case, step case) in the comment.
- Cuts: avoid. Use `once/1`, `->`, `\+` only where needed and say why in a comment.
- Prefer pure relations and pattern-matching in clause heads over `if-then-else` chains.
- No singleton-variable warnings, no discontiguous warnings. Load the file and confirm zero warnings.
- Keep helper predicates small (one job each). Put the public predicates (`generate_equation/2`, `all_equations/2`, `count_equations/2`) at the top, helpers below.
## 4. P2 specification (the AI must get all of this right)
 
Input: a list of non-negative integers `n1..nk`. Output: equations `L=R` where `L` is an expression over `n1..nj`, `R` an expression over `n(j+1)..nk`, for some `1 <= j < k`.
 
**Expressions**
- A single number, or two expressions joined by `+`, `-`, `*` or `/` (parentheses optional, they only matter for the printed form).
- Every number used exactly once, in the given order. No unary minus. Digits are never joined into bigger numbers.
- Sub-expression values may be negative (e.g. `3-5`).
- `/` only when **exact** (no remainder) and the **divisor is not 0**. Applies to **every** division inside an expression, not just the outermost.
- The two sides must have the same integer value.
**Output format (canonical string)**
- An SWI-Prolog **string** (not atom, not code list), no spaces, decimal numbers, e.g. `"4*2=5+3"`.
- Precedence: `*` and `/` bind tighter than `+` and `-`; operators are left-associative.
- Left operand: parenthesised **only if** its top operator has **lower** precedence than its parent's.
- Right operand: parenthesised if its top operator has **same or lower** precedence than its parent's.
- A single number is never parenthesised.
- Consequence: every distinct expression tree gives a distinct string, so `1+(2+3)` and `1+2+3` are **different** equations and both count.
- Reference cases: `(4+2)*3`, `4+2*3`, `8/4*2` (= `(8/4)*2`), `8/(4*2)`, `1-2-3` (= `(1-2)-3`), `1-(2-3)`, `1+(2+3)`, `1+2+3` (= `(1+2)+3`).
**Predicates**
- `generate_equation(+List, -Equation)`: one valid equation. **Fails** (no loop, no error) if none exists, including for `[]` and `[X]`.
- `all_equations(+List, -Equations)`: all valid equations, **no duplicates**, sorted with `sort/2` (standard order of terms; strings compare by character codes). `[]` if none.
- `count_equations(+List, -N)`: `N` is the length of the `all_equations` list.
**Given examples (must be in the test file)**
- `all_equations([4,2,5,3], Es)` gives `["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3", "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]`.
- `generate_equation([4,2,5,3], E)`: `E` is one of those seven.
- `generate_equation([2,3,4], E)` fails; `all_equations([2,3,4], Es)` gives `Es = []`.
- `all_equations([2,4,8], Es)` gives `Es = ["2*4=8"]`.
**Hard constraints**
- Do **not** build a string and parse it back (`term_to_atom`, `read_term_from_atom`, `number_codes` round trips, `atom_to_term`, `term_string` into `is`) to evaluate. Evaluate the tree structurally.
- No `assert`/`retract`/global variables. No printing (`print`, `format(user_output,...)`, `writeln`, etc.).
## 5. Suggested design for P2 (build it in small units, one prompt each)
 
1. `split(+List, -Left, -Right)`: all splits into two non-empty parts (`append/3`).
2. `expr(+Numbers, -Tree, -Value)`: all expression trees over a non-empty list.
   - single number: `Tree = num(N)`, `Value = N`;
   - otherwise split the list, build `Tree = op(Op, TL, TR)` for `Op` in `+ - * /`, compute `Value` via an eval helper.
3. `apply_op(+Op, +A, +B, -V)`: `+ - *` via `is`; for `/` require `B =\= 0` and `A mod B =:= 0` (check divisor first), then `V is A // B`. **Never** use `/` on integers and hope for a clean result.
4. `prec(+Op, -P)`: `+`,`-` give 1; `*`,`/` give 2.
5. `tree_string(+Tree, -String)` implementing the paren rule above (number -> `number_string/2` or `format(string(S), "~d", [N])`).
6. `equation(+List, -String)`: split the whole list into left/right, build trees with equal values, join as `"L=R"` using `format(string(S), "~s=~s", ...)` or `string_concat/3`.
7. Public predicates: `generate_equation/2` (first solution, e.g. `equation(List, E), !` or `once/1`), `all_equations/2` (`findall/3` then `sort/2`), `count_equations/2` (`length/2`).
Performance note: the number of trees grows fast (Catalan x 4^(k-1)). Do not recompute the same sub-list expressions needlessly, but do not use the database to cache. Keep the straightforward version first, then optimise only if a test is too slow.
 
## 6. How to run and test
 
Put tests in `tests/P2_tests.pl` (a separate file, so it does not break the "only definitions" rule of the solution file). The test file may consult the solution and use plain goals.
 
Quick checks from the shell:
 
```
swipl -q -f id_q2.pl -g "all_equations([4,2,5,3],Es),print(Es),nl" -t halt
swipl -q -f id_q2.pl -g "( generate_equation([2,3,4],_) -> writeln(wrong) ; writeln(ok_fails) )" -t halt
swipl -q -f id_q2.pl -g "count_equations([4,2,5,3],N),writeln(N)" -t halt
```
 
Test file must cover at least:
- all four examples from section 4;
- `[]`, `[7]` (fail / `[]` / count 0);
- `[0,0]` (should give `"0=0"`), a list with zeros where division by zero is tempting (e.g. `[5,0,0]`);
- inexact division rejected (e.g. `[5,2,2]`: `5/2` must not count);
- negative intermediate values (e.g. `[3,5,2]` style: `3-5` as a sub-expression);
- paren-rule cases: `1+(2+3)` vs `1+2+3`, `8/(4*2)` vs `8/4*2`, `1-(2-3)` vs `1-2-3` (use lists whose targets force these, and test `tree_string/2` directly);
- result is a **string**: `all_equations(L, [E|_]), string(E)` succeeds;
- sorted and duplicate-free: `all_equations(L, Es), sort(Es, Es)`;
- `count_equations(L, N)` equals `length` of `all_equations` list;
- load check: `swipl -q -f id_q2.pl -t halt` prints **nothing** and shows **no warnings**.
## 7. Self-review checklist (apply before answering, every time)
 
- [ ] Only allowed libraries; no `assert`/`retract`/`nb_setval`/`b_setval`.
- [ ] No `initialization`, no `halt`, no top-level goals, nothing printed on load.
- [ ] No printing inside P2 predicates.
- [ ] Output is a **string**, not an atom/code list; no spaces.
- [ ] Division: divisor nonzero is checked **before** `mod`; exactness checked for **every** division; integer result via `//`.
- [ ] Paren rule: left paren only if strictly lower precedence; right paren if same or lower; numbers never parenthesised.
- [ ] Split guarantees both sides non-empty, so `[]` and `[X]` fail naturally.
- [ ] No string-parse-eval trick anywhere.
- [ ] `all_equations/2` uses `findall/3` + `sort/2` (dedupe + order); `[]` when none.
- [ ] `generate_equation/2` fails cleanly (no exception) on `[]`, `[X]`, and unsolvable lists.
- [ ] No singleton/discontiguous warnings on load.
- [ ] All examples in section 4 pass, plus the edge cases in section 6.
- [ ] Each predicate has a header comment with declarative (and recursive, if applicable) reading.
- [ ] The answer covers **one unit only** (decomposition rule), and the prompt is logged in `prompts/P2.md`.
## 8. Known failure modes of AI tools for Prolog (check for these)
 
1. **Using `/` for integer division.** In SWI-Prolog `5/2` is `2.5` and `4/2` is `2`; checking "result is integer" afterwards is fragile. Use `B =\= 0, A mod B =:= 0, V is A // B`.
2. **`mod` or `//` with zero divisor** raising an evaluation error. Check `B =\= 0` first.
3. **Parse-back evaluation** (`term_to_atom`, `atom_to_term`, `term_string`, then `is`). Explicitly forbidden here.
4. **Returning atoms or code lists** instead of strings; or `format(atom(A), ...)` where `string(S)` is needed. Use `format(string(S), ...)`.
5. **Wrong parenthesisation**, typically parenthesising both operands symmetrically, or treating `-` and `/` right operands like `+` and `*`. Follow the left/right asymmetric rule exactly.
6. **Forgetting that negative sub-values are allowed** and rejecting them, or accepting unary minus.
7. **Joining digits** (treating `[4,2]` as 42) or reordering the numbers.
8. **Missing the split into L and R** (only evaluating one expression, or requiring `=` only at the very end of a left-to-right scan). The `=` splits the list into two independent expression trees.
9. **Forgetting `sort/2`**, using `msort/2` (keeps duplicates) or `sort/4` with a custom order. Required: `sort/2`.
10. **Choice-point leaks and infinite loops**: unbounded `append/3` with unbound first two arguments, left recursion in `expr`. Always recurse on a strictly smaller list.
11. **Printing debug output** (`writeln`, `print_message`) that pollutes graded stdout.
12. **Adding `:- initialization(main).`** or `halt.` at the end. Forbidden.
13. **Using `assert` for memoisation** or `nb_setval` counters to count solutions. Forbidden.
14. **Using libraries outside the allowed list** (`dcg/basics`, `clpfd`, `strings`, `plunit` inside the solution file).
15. **Hallucinated predicates** (e.g. `string_format/3`, `list_split/3`). Verify every builtin against the SWI-Prolog 9 manual or by running `?- apropos(...)` / `help(...)`.
16. **Claiming code works without running it.** Always run the commands in section 6 and report actual output.
17. **Giving the whole of P2 in one answer** (violates the decomposition rule).
 