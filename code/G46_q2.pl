%% split(+List, -Left, -Right)
%  Declarative reading: List is Left followed by Right, and both are non-empty.
%  Recursive reading: the first clause makes the shortest split; the second
%  moves the boundary one element right and recurses on the remaining suffix.
split([First, Second | Rest], [First], [Second | Rest]).
split([First, Second | Rest], [First | Left], Right) :-
    split([Second | Rest], Left, Right).
%% apply_op(+Op, +A, +B, -V)
%  Declarative reading: V is the integer result of applying Op to A and B;
%  division succeeds only for a nonzero divisor and an exact quotient.
apply_op(+, A, B, V) :-
    V is A + B.
apply_op(-, A, B, V) :-
    V is A - B.
apply_op(*, A, B, V) :-
    V is A * B.
apply_op(/, A, B, V) :-
    B =\= 0,
    A mod B =:= 0,
    V is A // B.