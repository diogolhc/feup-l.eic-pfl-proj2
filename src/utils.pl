:- use_module(library(between)).

/*
    Checks if a given number is even.
*/
% even(+Num)
even(Num):-
    0 is mod(Num, 2).


/*
    Negation as failure.
*/
% not(+X)
not(X):- X, !, fail.
not(_X).


/*
    Gets the Matrix with Height and Width filled with Num.
*/
% num_matrix(+Num, +Height, +Width, -Matrix)
num_matrix(_, 0, _, []):-
    !.
num_matrix(Num, Height, Width, [H|T]):-
    H1 is Height-1,
    num_line(Num, Width, H),
    num_matrix(Num, H1, Width, T).


/*
    Gets the Line with Width filled with Num.
*/
% num_line(+Num, +Width, -Line)
num_line(_, 0, []):-
    !.
num_line(Num, Width, [Num|T]):-
    W1 is Width - 1,
    num_line(Num, W1, T).


/*
    Multiplies Matrix by the given Scalar into MatrixMultiplied.
*/
% matrix_multiply_scalar(+Scalar, +Matrix, -MatrixMultiplied)
matrix_multiply_scalar(_, [], []):-
    !.
matrix_multiply_scalar(Scalar, [H1|T1], [H2|T2]):-
    list_multiply_scalar(Scalar, H1, H2),
    matrix_multiply_scalar(Scalar, T1, T2).


/*
    Multiplies List by the given Scalar into ListMultiplied.
*/
% list_multiply_scalar(+Scalar, +List, -ListMultiplied)
list_multiply_scalar(_, [], []):-
    !.
list_multiply_scalar(Scalar, [H1|T1], [H2|T2]):-
    H2 is Scalar * H1,
    list_multiply_scalar(Scalar, T1, T2).


/*
    Performs a subtraction of coordinates to get the translation associated.
*/
% sub_coordinates(+[C1,L1], +[C2,L2], ?[C3,L3])
sub_coordinates([C1,L1], [C2,L2], [C3,L3]):-
    C3 is C1-C2,
    L3 is L1-L2.


/*
    Given a Matrix and coordinates (indexes) gets the corresponding element Elem.
    Or, given a Matrix, gets coordinates inside it and the Elem at those coordinates.
*/
% matrix_at(+Matrix, ?[C,L], -Elem)
matrix_at(Matrix, [C, L], Elem):-
    length(Matrix, Height),
    H1 is Height-1,
    between(0, H1, L),
    nth0(L, Matrix, Line),
    length(Line, Width),
    W1 is Width-1,
    between(0, W1, C),
    nth0(C, Line, Elem).


/*
    Gets the ModifiedList of given List with Elem at given Index.
*/
% list_put_at(+List, +Index, +Elem, -ModifiedList)
list_put_at([_|Tail], 0, Elem, [Elem|Tail]).

list_put_at([Head|Tail1], Index, Elem, [Head|Tail2]):-
    Index > 0,
    I1 is Index-1,
    list_put_at(Tail1, I1, Elem, Tail2).


/*
    Gets the ModifiedMatrix of given Matrix with Elem at given indexes ([C,L]).
    Does not perform bounds checks.
*/
% matrix_put_at(+Matrix, +[C,L], +Elem, -ModifiedMatrix)
matrix_put_at([Head1|Tail], [C, 0], Elem, [Head2|Tail]):-
    list_put_at(Head1, C, Elem, Head2).

matrix_put_at([Head|Tail1], [C, L], Elem, [Head|Tail2]):-
    L > 0,
    L1 is L-1,
    matrix_put_at(Tail1, [C, L1], Elem, Tail2).


/*
    Filters the negative values into 0's of a given List into FilteredList.
*/
% filter_negatives(+List, -FilteredList)
filter_negatives([], []).
filter_negatives([Elem | Rest], [0 | FilteredRest]):- 
    Elem < 0,
    filter_negatives(Rest, FilteredRest).
filter_negatives([Elem | Rest], [Elem | FilteredRest]):- 
    filter_negatives(Rest, FilteredRest).


/*
    Sums all the elemts in a List.
*/
% sum_list(+List, -Sum)
sum_list([], 0).
sum_list([H|T], Sum):-
   sum_list(T, Rest),
   Sum is H + Rest.


/*
    Checks if the given Matrix has values of the given Range (postive or negative values).
*/
% matrix_has_range(+Matrix, +Range)
matrix_has_range(Matrix, positive):-
    matrix_at(Matrix, _, Elem),
    Elem > 0.
matrix_has_range(Matrix, negative):-
    matrix_at(Matrix, _, Elem),
    Elem < 0.
