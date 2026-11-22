
:- begin_tests(p1).

:- consult('../code/46_q1.pl').


% Test 1: The first eight clues should produce 3 solutions.
test(count_first_eight_clues) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    N =:= 3.


% Test 2: Adding clue 9 should leave exactly one solution.
test(count_all_nine_clues) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N),
    N =:= 1.


% Test 3: The solution should satisfy all the first eight clues.
test(solution_satisfies_first_eight) :-
    once(solve(S)),
    forall(
        between(1,8,N),
        clue(N,S)
    ).

% Test 4: Clue 9 should leave exactly one valid solution.
test(unique_solution_after_clue_nine) :-
    findall(
        S,
        (solve(S), clue(9,S)),
        Solutions
    ),
    length(Solutions, 1).


% Test 5: Check the actual surviving solution.
test(check_final_solution) :-
    once((
        solve(S),
        clue(9,S),
        S = [
            p('Alex',design,java,embedded),
            p('Ben',development,javascript,web),
            p('Carla',testing,python,'AI'),
            p('Dana',research,'c++',data)
        ]
    )).


:- end_tests(p1).
