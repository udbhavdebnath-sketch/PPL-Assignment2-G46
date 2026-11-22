:- consult('../code/G46_q2.pl').

%% test_apply_op.
%  Succeeds when apply_op/4 returns the expected results and rejects
%  inexact or zero-divisor division. Negation checks failure cases.
test_apply_op :-
    apply_op(+, 2, 3, 5),
    apply_op(-, 5, 2, 3),
    apply_op(*, 3, 4, 12),
    apply_op(/, 4, 2, 2),
    apply_op(/, 0, 5, 0),
    apply_op(/, -6, 3, -2),
    apply_op(/, 6, -3, -2),
    \+ apply_op(/, 5, 2, _),
    \+ apply_op(/, 4, 0, _),
    \+ apply_op(/, 0, 0, _),
    \+ apply_op(/, -7, 2, _),
    call_cleanup(apply_op(+, 2, 3, 5), PlusDone = true),
    nonvar(PlusDone),
    call_cleanup(apply_op(-, 5, 2, 3), MinusDone = true),
    nonvar(MinusDone),
    call_cleanup(apply_op(*, 3, 4, 12), TimesDone = true),
    nonvar(TimesDone),
    call_cleanup(apply_op(/, 4, 2, 2), DivideDone = true),
    nonvar(DivideDone).