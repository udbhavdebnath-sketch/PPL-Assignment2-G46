# CS F301 – Principles of Programming Languages
## Assignment 2: Logic and Functional Programming

**Group ID:** G46

### Group Members

| Name | Student ID |
|---|---|
| Udbhav Debnath | 2024A7PS0107H |
| Naman Singhal | 2024A7PS0121H |
| Varad Thombre | 2024A7PS0148H |
| Mehul Gupta | 2024A7PS0168H |

**Course:** CS F301 – Principles of Programming Languages  
**Languages:** Prolog (SWI-Prolog 9.x) and Scheme (Racket 8.x)

---

## 1. Assignment Overview

This assignment explores the concepts of Logic Programming and Functional Programming through four problems implemented using Prolog and Scheme.

The assignment consists of:

| Problem | Language | Description |
|---|---|---|
| P1 | Prolog | Department Assignment Puzzle |
| P2 | Prolog | Form a Valid Arithmetic Equation |
| S1 | Scheme | Binary Tree Traversals |
| S2 | Scheme | Conditionally Insert into a Nested List |

Each problem focuses on different programming concepts, including logical constraints, backtracking, recursive expression generation, tree traversal, higher-order functions and recursive list processing.

## 2. Repository Structure

The repository follows the directory structure specified in the assignment.

```text
PPL-Assignment2-G46/
│
├── code/
│   ├── G46_q1.pl
│   ├── G46_q2.pl
│   ├── G46_q3.rkt
│   └── G46_q4.rkt
│
├── tests/
│   ├── P1 test file
│   ├── P2 test file
│   ├── S1 test file
│   └── S2 test file
│
├── skills/
│   ├── prolog-dev/
│   │   └── SKILL.md
│   │
│   └── scheme-dev/
│       └── SKILL.md
│
├── prompts/
│   ├── P1.md
│   ├── P2.md
│   ├── S1.md
│   └── S2.md
│
├── P1_REPORT.md
└── README.md
```

## 3. Problem Descriptions and Implementations

### P1 – Department Assignment Puzzle (Prolog)

**Objective:** Solve a department assignment puzzle involving four friends: Alex, Ben, Carla and Dana.

Each friend is assigned a unique:
- Department
- Favourite programming language
- Project preference

**Implementation:**
- Represent each friend using the `p(Name, Dept, Lang, Project)` structure.
- Implement the eight given clues as individual `clue/2` predicates.
- Generate a valid assignment satisfying the specified constraints.
- Implement `count_solutions/2` to count solutions for a selected set of clues.
- Introduce a ninth clue that makes the puzzle have exactly one solution.

**Key Concepts:** Constraint satisfaction, logical inference, unification, backtracking and solution enumeration.

**Execution:**

```bash
swipl -q -f code/G46_q1.pl -g main -t halt
```

### P2 – Form a Valid Arithmetic Equation (Prolog)

**Objective:** Given a list of non-negative integers, construct arithmetic equations by inserting operators and exactly one equality sign while preserving the original order of numbers.

**Implementation:**
- Generate valid arithmetic expressions using `+`, `-`, `*` and `/`.
- Divide the input list into two non-empty sides of an equation.
- Ensure division is exact and division by zero is avoided.
- Ensure both sides evaluate to the same integer value.
- Generate equations in canonical string representation.
- Implement `generate_equation/2` to generate one valid equation.
- Implement `all_equations/2` to generate all valid equations without duplicates, sorted using `sort/2`.
- Implement `count_equations/2` to calculate the number of valid equations.

**Key Concepts:** Recursive expression generation, arithmetic evaluation, operator precedence, associativity, backtracking and canonical expression representation.

**Execution:**

```bash
swipl -q -f code/G46_q2.pl -g "generate_equation([4,2,5,3],E),writeln(E)" -t halt
```

### S1 – Binary Tree Traversals (Scheme)

**Objective:** Implement recursive functions to perform binary tree traversals and calculate tree properties.

A binary tree is represented as either an empty list or a three-element list containing a value, left subtree and right subtree.

**Implementation:**

1. `print-inorder`: Prints the inorder traversal of a binary tree.
2. `print-all-traversals`: Prints the inorder, preorder and postorder traversals on separate lines.
3. `print-height-and-leaves`: Calculates and prints the height and total number of leaves.

**Key Concepts:** Tree recursion, structural recursion, inorder traversal, preorder traversal, postorder traversal, height calculation and leaf counting.

**Execution:**

```bash
racket code/G46_q3.rkt
```

### S2 – Conditionally Insert into a Nested List (Scheme)

**Objective:** Implement a function that inserts an element at the beginning of every list whose length is less than a specified threshold, including lists nested at any depth.

**Implementation:**
- Implement `my-length` to calculate the length of a list recursively.
- Implement `my-map` to apply a function to each element of a list.
- Implement `make-inserter` as a higher-order function that returns an insertion function based on a supplied length predicate.
- Implement `insert-if-short` using `make-inserter`.
- Implement `print-insert-result` to read the input values and print the resulting nested list.

**Key Concepts:** Nested list recursion, higher-order functions, closures, recursive list processing and functional programming.

**Execution:**

```bash
racket code/G46_q4.rkt
```

The S2 program reads three inputs from standard input in the following order:

1. Element to insert (`x`)
2. Nested list (`lst`)
3. Length threshold (`n`)

## 4. Development Environment

The assignment uses the following environments:

| Component | Requirement |
|---|---|
| Prolog | SWI-Prolog 9.x |
| Scheme | Racket 8.x |
| Scheme language declaration | `#lang racket/base` |
| Version control | Git and GitHub |

### Prolog

The Prolog programs are executed using SWI-Prolog.

P1 is executed through `main/0`, while other predicates can be invoked directly through the Prolog command line.

### Scheme

The Scheme programs are implemented using Racket.

Both Scheme files use `#lang racket/base` and contain definitions only. Functions are not invoked at the top level, and loading the files should not produce additional output. The grader supplies its own function calls.

## 5. Testing

The `tests/` directory contains test cases for all four problems.

Testing covers:
- Examples provided in the assignment statement.
- Normal input cases.
- Boundary and edge cases.
- Empty lists and cases with no valid solution, where applicable.
- Multiple valid solutions and solution enumeration.
- Nested structures and recursive function behaviour.

Each problem has its own test file to facilitate independent verification.

## 6. AI-Assisted Development

Generative AI tools were used as development assistance during the assignment.

The AI assistance followed the assignment's decomposition rule: each prompt focused on an individual unit of work, such as a predicate, function, test case, debugging task or code review, rather than requesting the complete solution to an entire problem in a single prompt.

Two reusable AI skill files were created:

- **prolog-dev:** Provides instructions and coding guidelines for Prolog development.
- **scheme-dev:** Provides instructions and coding guidelines for Scheme development.

The `prompts/` directory contains the prompts used during the development of each problem, organized separately into P1, P2, S1 and S2.

## 7. Assignment Deliverables

The repository includes the following deliverables:

- Four implementation files covering P1, P2, S1 and S2.
- Individual test files for all four problems.
- Two reusable AI skill files for Prolog and Scheme.
- Four problem-wise AI prompt documentation files.
- `P1_REPORT.md`, documenting the solution count for clues 1–8 and its interpretation as required in P1.b.
- This README documenting the complete assignment and repository structure.

## 8. Programming Constraints

The implementations follow the restrictions specified in the assignment:

- Prolog solutions avoid `assert`, `retract` and global variables.
- Only the permitted Prolog libraries are used.
- Scheme implementations use only the explicitly permitted built-in functions.
- Scheme solutions avoid mutation, prohibited library functions and conventional looping constructs.
- Prolog files contain definitions without initialization directives.
- Scheme files contain definitions without top-level function calls.
- The original order of numbers and recursive list/tree structures is preserved wherever required.

---

**Course:** CS F301 – Principles of Programming Languages  
**Assignment:** Assignment 2 – Logic and Functional Programming  
**Group:** G46
