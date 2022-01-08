:- use_module(library(between)). % TODO can we use this?

% TODO use between if we can use it ^^ is more versatile
% number_between(+Num, +Min, +Max)
number_between(Num, Min, Max):-
    Num >= Min, Num =< Max.


% even(+Num)
even(Num):-
    0 is mod(Num, 2).

% not(+X)
not(X):- X, !, fail.
not(_X).


% num_matrix(+Num, +Height, +Width, -Matrix)
num_matrix(_, 0, _, []):-
    !.
num_matrix(Num, Height, Width, [H|T]):-
    H1 is Height-1,
    num_line(Num, Width, H),
    num_matrix(Num, H1, Width, T).


% num_line(+Num, +Width, -Line)
num_line(_, 0, []):-
    !.
num_line(Num, Width, [Num|T]):-
    W1 is Width - 1,
    num_line(Num, W1, T).


% matrix_multiply_scalar(+Scalar, +Matrix, -MatrixMultiplied)
matrix_multiply_scalar(_, [], []):-
    !.
matrix_multiply_scalar(Scalar, [H1|T1], [H2|T2]):-
    list_multiply_scalar(Scalar, H1, H2),
    matrix_multiply_scalar(Scalar, T1, T2).


% list_multiply_scalar(+Scalar, +List, -ListMultiplied)
list_multiply_scalar(_, [], []):-
    !.
list_multiply_scalar(Scalar, [H1|T1], [H2|T2]):-
    H2 is Scalar * H1,
    list_multiply_scalar(Scalar, T1, T2).


% sub_coordinates(+[C1,L1], +[C2,L2], ?[C3,L3])
sub_coordinates([C1,L1], [C2,L2], [C3,L3]):-
    C3 is C1-C2,
    L3 is L1-L2.


% TODO this is more like: matrix_at(+Matrix, ?[C,L], -Elem)
% matrix_at(+Matrix, +[C,L], -Elem)
matrix_at(Matrix, [C, L], Elem):-
    length(Matrix, Height),
    H1 is Height-1,
    between(0, H1, L),
    nth0(L, Matrix, Line),
    length(Line, Width),
    W1 is Width-1,
    between(0, W1, C),
    nth0(C, Line, Elem).


% list_put_at(+List, +Index, +Elem, -ModifiedList)
list_put_at([_|Tail], 0, Elem, [Elem|Tail]).

list_put_at([Head|Tail1], Index, Elem, [Head|Tail2]):-
    Index > 0,
    I1 is Index-1,
    list_put_at(Tail1, I1, Elem, Tail2).


% no bound checks
% matrix_put_at(+Matrix, +[C,L], +Elem, -ModifiedMatrix)
matrix_put_at([Head1|Tail], [C, 0], Elem, [Head2|Tail]):-
    list_put_at(Head1, C, Elem, Head2).

matrix_put_at([Head|Tail1], [C, L], Elem, [Head|Tail2]):-
    L > 0,
    L1 is L-1,
    matrix_put_at(Tail1, [C, L1], Elem, Tail2).
