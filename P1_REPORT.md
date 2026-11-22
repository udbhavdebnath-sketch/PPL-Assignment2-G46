# P1 – Department Assignment Puzzle

## 1. Problem Representation

The problem consists of four friends: Alex, Ben, Carla and Dana. Each friend is assigned a department, a favourite programming language and a project preference.

Each attribute must be used exactly once.

The solution is represented using the Prolog structure:

`p(Name, Department, Language, Project)`

The complete solution is represented as a list of four such terms in the order Alex, Ben, Carla and Dana.

## 2. Implementation

### P1.a – Generating a Solution

The `base_solution/1` predicate uses permutations to generate possible assignments while ensuring that every attribute is used exactly once.

The `clue/2` predicates represent the eight given conditions independently.

The `solve/1` predicate generates a base solution and checks whether it satisfies all eight clues.

The `main/0` predicate prints one valid solution in the required format.

### P1.b – Counting Solutions

The `count_solutions(Active, N)` predicate counts the number of solutions satisfying the selected active clues.

It uses:
- `base_solution/1` to generate possible assignments.
- `satisfies_active/2` to check only the selected clues.
- `findall/3` to collect all valid solutions.
- `length/2` to calculate the total count.

For the first eight clues:

`count_solutions([1,2,3,4,5,6,7,8], N).`

**Output: N = 3**

This means that the original eight clues allow three valid assignments. Therefore, the puzzle does not have a unique solution with only the given clues.

## 3. P1.c – Adding Clue 9

To make the puzzle uniquely solvable, the following additional clue was introduced:

**Clue 9:** The friend who prefers embedded projects works in the design department.

This clue is implemented independently using `clue(9, Solution)`.

After adding the ninth clue, the solution count becomes:

`count_solutions([1,2,3,4,5,6,7,8,9], N).`

**Output: N = 1**

This confirms that exactly one solution remains.

### Final Solution

The unique assignment is:

| Friend | Department | Language | Project |
|---|---|---|---|
| Alex | Design | Java | Embedded |
| Ben | Development | JavaScript | Web |
| Carla | Testing | Python | AI |
| Dana | Research | C++ | Data |

## 4. Testing

Automated tests are provided in `tests/P1_tests.pl`.

The test cases verify:

1. The number of solutions using the first eight clues is three.
2. The number of solutions using all nine clues is one.
3. A generated solution satisfies the first eight clues.
4. Clue 9 leaves exactly one valid solution.
5. The final solution matches the expected assignment.

All five automated tests passed successfully using SWI-Prolog 9.2.9.

## 5. Conclusion

The original eight clues produce three valid assignments, which shows that the puzzle is not uniquely determined.

By introducing the ninth clue, the number of valid assignments is reduced to exactly one. The implementation uses Prolog predicates and backtracking to generate and verify the assignments without using global variables, `assert` or `retract`.