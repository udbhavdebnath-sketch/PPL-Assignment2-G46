
:- use_module(library(plunit)).
:- consult('code/G17_q2.pl').

:- begin_tests(p2_expression_engine).

% -------------------------
% Tests for split/3
% -------------------------

test(split_all_prefixes) :-
    findall(Left-Right, split([4,2,5,3], Left, Right), Splits),
    Splits == [
        [4]-[2,5,3],
        [4,2]-[5,3],
        [4,2,5]-[3]
    ].

test(split_empty, [fail]) :-
    split([], _, _).

test(split_singleton, [fail]) :-
    split([5], _, _).


% -------------------------
% Tests for apply_op/4
% -------------------------

test(addition) :-
    apply_op('+', 8, 5, 13).

test(subtraction) :-
    apply_op('-', 8, 5, 3).

test(multiplication) :-
    apply_op('*', 8, 5, 40).

test(exact_division) :-
    apply_op('/', 8, 2, 4).

test(non_exact_division, [fail]) :-
    apply_op('/', 5, 2, _).

test(division_by_zero, [fail]) :-
    apply_op('/', 5, 0, _).

test(negative_result) :-
    apply_op('-', 2, 5, -3).


% -------------------------
% Tests for expr/3
% -------------------------

test(expr_single_number) :-
    expr([5], num(5), 5).

test(expr_two_numbers_all_operators) :-
    findall(Op-Value,
        (member(Op, ['+', '-', '*', '/']),
         expr([8,2], op(Op, num(8), num(2)), Value)),
        Results),
    Results == [
        '+'-10,
        '-'-6,
        '*'-16,
        '/'-4
    ].

test(expr_left_associated_tree) :-
    expr([4,2,5],
         op('+', op('+', num(4), num(2)), num(5)),
         11).

test(expr_right_associated_tree) :-
    expr([4,2,5],
         op('+', num(4), op('+', num(2), num(5))),
         11).

test(expr_negative_intermediate) :-
    expr([2,5], op('-', num(2), num(5)), -3).

test(expr_non_exact_division, [fail]) :-
    expr([5,2], op('/', num(5), num(2)), _).

test(expr_division_by_zero, [fail]) :-
    expr([4,2,2],
         op('/', num(4), op('-', num(2), num(2))),
         _).

test(expr_empty_list, [fail]) :-
    expr([], _, _).

test(expr_three_numbers_count) :-
    findall(Tree-Value, expr([4,2,5], Tree, Value), Results),
    length(Results, 21).

:- end_tests(p2_expression_engine).
