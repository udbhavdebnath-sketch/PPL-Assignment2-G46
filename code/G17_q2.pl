%% split(+List, -Left, -Right)
%  Declarative reading: List is Left followed by Right, both non-empty.
%  Recursive reading: the first element starts Left; either Left ends there,
%  or the remaining list is split again to extend Left by one element.
split([First, Second|Rest], [First], [Second|Rest]).
split([First, Second|Rest], [First|Left], Right) :-
    split([Second|Rest], Left, Right).
