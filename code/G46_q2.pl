%% split(+List, -Left, -Right)
%  Declarative reading: List is Left followed by Right, and both are non-empty.
%  Recursive reading: the first clause makes the shortest split; the second
%  moves the boundary one element right and recurses on the remaining suffix.
split([First, Second | Rest], [First], [Second | Rest]).
split([First, Second | Rest], [First | Left], Right) :-
    split([Second | Rest], Left, Right).