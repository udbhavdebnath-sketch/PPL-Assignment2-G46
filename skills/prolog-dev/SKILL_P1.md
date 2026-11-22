
---
name: prolog-dev-p1
description: Instructions for solving the P1 department assignment puzzle using SWI-Prolog 9.x.
---

# Prolog Development Skill - P1

## 1. Language and Environment

- Use SWI-Prolog 9.x.
- Follow declarative Prolog programming.
- Use only the libraries allowed in the assignment: lists, apply, yall and aggregate.
- Do not use assert, retract or global variables.
- The solution file must contain only definitions.
- Do not use initialization directives or print anything when loading the file.

## 2. Coding Conventions

- Use meaningful predicate names.
- Use lowercase for predicate names and atoms.
- Use uppercase for variables.
- Add comments explaining the purpose of each predicate.
- Keep the code simple and readable.
- Avoid unnecessary cuts and side effects.

## 3. Problem Representation

Represent every friend using the term:

p(Name, Department, Language, Project)

The solution must contain four friends in this order:

Alex, Ben, Carla and Dana.

Each department, language and project must be used exactly once.

Use permutations or other suitable Prolog relations to generate valid assignments instead of hard-coding the answer.

## 4. Clue Implementation

- Implement every clue separately using clue(N, Solution).
- Each clue must check only its corresponding condition.
- Clues must work on a fully filled solution.
- Keep the predicates independent and easy to understand.
- Clue 9 must not mention any friend by name.

## 5. Backtracking and Solution Generation

- Use Prolog unification and backtracking to generate possible assignments.
- Apply all active clues to filter invalid solutions.
- Do not stop searching before all required solutions have been considered.
- Do not hard-code the final solution.

## 6. Solution Counting

Implement count_solutions(Active, N).

- Active contains the clue numbers that must be checked.
- Ignore clues that are not included in Active.
- Use findall/3 or aggregate_all/3.
- Count every valid solution.

## 7. Main Predicate

The main/0 predicate must:

- Generate a solution satisfying clues 1 to 8 and clue 9.
- Print the four friends in the specified order.
- Follow the exact output format in the assignment.
- Avoid additional debug output.

## 8. Testing

Test the following:

- Individual clue predicates.
- Solutions satisfying clues 1 to 8.
- Solution counts for different active clue sets.
- Uniqueness after adding clue 9.
- Correct output from main/0.
- Cases where no solution exists.

Run the program using:

swipl -q -f code/46_q1.pl -g main -t halt

## 9. Self-Review Checklist

- [ ] All eight original clues are implemented.
- [ ] Clue 9 is implemented separately.
- [ ] Every attribute value is used exactly once.
- [ ] No solution is hard-coded.
- [ ] count_solutions/2 handles arbitrary active clue lists.
- [ ] Clues 1 to 8 produce the correct solution count.
- [ ] All nine clues produce exactly one solution.
- [ ] Output formatting is correct.
- [ ] No prohibited predicates or libraries are used.
- [ ] The file loads without warnings.

## 10. Common AI Mistakes in Prolog

- Confusing unification (=) with arithmetic comparison (=:=).
- Forgetting that Prolog uses backtracking to find alternatives.
- Using cuts that accidentally remove valid solutions.
- Hard-coding a solution instead of generating it.
- Counting duplicate solutions.
- Checking only some active clues instead of all requested clues.
- Using incorrect atom names or quotation marks.
- Printing additional debugging information.
