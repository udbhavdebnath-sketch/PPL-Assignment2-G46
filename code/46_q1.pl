
% Department Assignment Puzzle - P1
% Group 46

:- use_module(library(lists)).

% Generate all possible assignments.
% Each attribute is used exactly once.

base_solution(Solution) :-

    permutation(
        [research, development, design, testing],
        [AlexDept, BenDept, CarlaDept, DanaDept]
    ),

    permutation(
        [python, java, 'c++', javascript],
        [AlexLang, BenLang, CarlaLang, DanaLang]
    ),

    permutation(
        ['AI', web, embedded, data],
        [AlexProject, BenProject, CarlaProject, DanaProject]
    ),

    Solution = [
        p('Alex', AlexDept, AlexLang, AlexProject),
        p('Ben', BenDept, BenLang, BenProject),
        p('Carla', CarlaDept, CarlaLang, CarlaProject),
        p('Dana', DanaDept, DanaLang, DanaProject)
    ].


% Clue 1:
% The AI project is not in research and is not Dana.

clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Name \= 'Dana',
    Dept \= research.


% Clue 2:
% Alex does not work in development and does not prefer C++.

clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.


% Clue 3:
% The person in testing likes Python.

clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).


% Clue 4:
% Ben prefers web and does not work in testing.

clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.


% Clue 5:
% The person who likes Java works in design.

clue(5, Solution) :-
    member(p(_, design, java, _), Solution).


% Clue 6:
% Carla does not prefer embedded and does not work in development.

clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Dept \= development,
    Project \= embedded.


% Clue 7:
% Dana does not like Java and works in research or testing.

clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).


% Clue 8:
% The person who prefers data works in research
% and does not use JavaScript.

clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.


% Generate a solution that satisfies all the original clues.

solve(Solution) :-
    base_solution(Solution),
    clue(1, Solution),
    clue(2, Solution),
    clue(3, Solution),
    clue(4, Solution),
    clue(5, Solution),
    clue(6, Solution),
    clue(7, Solution),
    clue(8, Solution).


% Print one valid solution in the required format.

main :-
    once(solve(Solution)),

    Solution = [
        p(Name1, Dept1, Lang1, Project1),
        p(Name2, Dept2, Lang2, Project2),
        p(Name3, Dept3, Lang3, Project3),
        p(Name4, Dept4, Lang4, Project4)
    ],

    format('~a = [~a, ~a, ~a]~n',
           [Name1, Dept1, Lang1, Project1]),

    format('~a = [~a, ~a, ~a]~n',
           [Name2, Dept2, Lang2, Project2]),

    format('~a = [~a, ~a, ~a]~n',
           [Name3, Dept3, Lang3, Project3]),

    format('~a = [~a, ~a, ~a]~n',
           [Name4, Dept4, Lang4, Project4]).


% Check whether a solution satisfies all the active clues.

satisfies_active([], _).

satisfies_active([ClueNo|Rest], Solution) :-
    clue(ClueNo, Solution),
    satisfies_active(Rest, Solution).


% Count the number of solutions satisfying the active clues.

count_solutions(Active, N) :-
    findall(
        Solution,
        (
            base_solution(Solution),
            satisfies_active(Active, Solution)
        ),
        Solutions
    ),
    length(Solutions, N).
