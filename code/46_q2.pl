%% split(+List, -Left, -Right)
%  Declarative reading: List is Left followed by Right, both non-empty.
%  Recursive reading: the first element starts Left; either Left ends there,
%  or the remaining list is split again to extend Left by one element.
split([First, Second|Rest], [First], [Second|Rest]).
split([First, Second|Rest], [First|Left], Right) :-
    split([Second|Rest], Left, Right).

%% apply_op(+Op, +A, +B, -Value)
%  Declarative reading: Value is the exact integer result of applying Op to A and B.
apply_op('+', A, B, Value) :-
    Value is A + B.
apply_op('-', A, B, Value) :-
    Value is A - B.
apply_op('*', A, B, Value) :-
    Value is A * B.
apply_op('/', A, B, Value) :-
    B =\= 0,
    A mod B =:= 0,
    Value is A // B.

%% expr(+Numbers, -Tree, -Value)
%  Declarative reading: Tree uses every number in Numbers once, in order, and
%  Value is its integer value using exact, nonzero-divisor arithmetic.
%  Recursive reading: a singleton is a number leaf; otherwise split Numbers
%  into two nonempty parts, recursively build each subtree, and join them with
%  an operator whose result is valid under apply_op/4.
expr([N], num(N), N).
expr(Numbers, op(Op, LeftTree, RightTree), Value) :-
    split(Numbers, LeftNumbers, RightNumbers),
    expr(LeftNumbers, LeftTree, LeftValue),
    expr(RightNumbers, RightTree, RightValue),
    member(Op, ['+', '-', '*', '/']),
    apply_op(Op, LeftValue, RightValue, Value).

%% prec(+Op, -Precedence)
%  Declarative reading: Precedence is the precedence level assigned to Op.
prec('+', 1).
prec('-', 1).
prec('*', 2).
prec('/', 2).

%% tree_string(+Tree, -String)
%  Declarative reading: String is the canonical, space-free representation of Tree.
tree_string(num(N), String) :-
    number_string(N, String).
tree_string(op(Op, LeftTree, RightTree), String) :-
    tree_string(LeftTree, LeftString),
    tree_string(RightTree, RightString),
    prec(Op, ParentPrecedence),
    % These conditionals apply the distinct left and right parenthesis rules.
    (   LeftTree = op(LeftOp, _, _),
        prec(LeftOp, LeftPrecedence),
        LeftPrecedence < ParentPrecedence
    ->  format(string(ParenthesizedLeft), "(~s)", [LeftString])
    ;   ParenthesizedLeft = LeftString
    ),
    (   RightTree = op(RightOp, _, _),
        prec(RightOp, RightPrecedence),
        RightPrecedence =< ParentPrecedence
    ->  format(string(ParenthesizedRight), "(~s)", [RightString])
    ;   ParenthesizedRight = RightString
    ),
    atom_string(Op, OperatorString),
    format(string(String), "~s~s~s", [ParenthesizedLeft, OperatorString, ParenthesizedRight]).

%% equation(+Numbers, -Equation)
%  Declarative reading: Equation joins equal-valued expressions over Numbers in order.
equation(Numbers, Equation) :-
    split(Numbers, LeftNumbers, RightNumbers),
    expr(LeftNumbers, LeftTree, LeftValue),
    expr(RightNumbers, RightTree, RightValue),
    LeftValue =:= RightValue,
    tree_string(LeftTree, LeftString),
    tree_string(RightTree, RightString),
    format(string(Equation), "~s=~s", [LeftString, RightString]).

%% generate_equation(+Numbers, -Equation)
%  Declarative reading: Equation is the first valid equation generated for Numbers.
%  once/1 limits this public predicate to the first solution of equation/2.
generate_equation(Numbers, Equation) :-
    once(equation(Numbers, Equation)).

%% all_equations(+Numbers, -Equations)
%  Declarative reading: Equations is the sorted, duplicate-free list of valid equations for Numbers.
all_equations(Numbers, Equations) :-
    findall(Equation, equation(Numbers, Equation), Generated),
    sort(Generated, Equations).

%% count_equations(+Numbers, -N)
%  Declarative reading: N is the number of unique valid equations for Numbers.
count_equations(Numbers, N) :-
    all_equations(Numbers, Equations),
    length(Equations, N).
    
