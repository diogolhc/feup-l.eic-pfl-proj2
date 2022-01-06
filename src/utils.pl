% number_between(+Number, +Min, +Max)
number_between(Number, Min, Max):-
    Number >= Min, Number =< Max.
