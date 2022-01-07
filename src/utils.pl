% number_between(+Num, +Min, +Max)
number_between(Num, Min, Max):-
    Num >= Min, Num =< Max.


% even(+Num)
even(Num):-
    0 is mod(Num, 2).


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

% sum_list(+List, -Sum)
sum_list([], 0).
sum_list([H|T], Sum) :-
   sum_list(T, Rest),
   Sum is H + Rest.

% filter_negatives(+ListIn, -ListOut) 
% TODO check sizes
filter_negatives([], []).
filter_negatives([H | T1], [0 | T2]) :- 
    H < 0,
    filter_negatives(T1, T2).
filter_negatives([H | T1], [H | T2]) :-
    filter_negatives(T1, T2).
