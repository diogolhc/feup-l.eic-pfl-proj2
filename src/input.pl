:- consult('utils.pl').

% read_number(-Number)
read_number(Number):-
    read_number(Number, 0).

read_number(Number, Number):-
    peek_code(10), !, skip_line.
read_number(Number, Accum):-
    get_code(Code),
    char_code('0', ZeroAscii),
    Num is Code - ZeroAscii,
    number_between(Num, 0, 9), !,
    Next is Accum*10 + Num,
    read_number(Number, Next).
read_number(Number, _):-
    write('Input is not a number.\n'),
    skip_line, !, read_number(Number, 0).


% read_letter(-LetterCode)
read_letter(LetterCode):-
    get_code(Code),
    char_code('a', ALowerAscii),
    char_code('z', ZLowerAscii),
    char_code('A', AUpperAscii),
    char_code('Z', ZUpperAscii),(
        number_between(Code, ALowerAscii, ZLowerAscii);
        number_between(Code, AUpperAscii, ZUpperAscii)
    ), 
    peek_code(10), !, skip_line,
    LetterCode is Code.
read_letter(LetterCode):-
    write('Input is not a letter.\n'),
    skip_line, !, read_letter(LetterCode).


% letter_code_to_index(+Code, -Index)
letter_code_to_index(Code, Index):- % lower case
    char_code('a', ALowerAscii),
    char_code('z', ZLowerAscii),
    !,
    number_between(Code, ALowerAscii, ZLowerAscii),
    Index is Code - ALowerAscii.
letter_code_to_index(Code, Index):- % upper case
    char_code('A', AUpperAscii),
    char_code('Z', ZUpperAscii),
    !,
    number_between(Code, AUpperAscii, ZUpperAscii),
    Index is Code - AUpperAscii.


% read_valid_row_index(+Size, -RowIndex) 
read_valid_row_index(Size, RowIndex):-
    read_number(RowNumber),
    RowIndex is Size - RowNumber,
    MaxIndex is Size-1,
    number_between(RowIndex, 0, MaxIndex),
    !.
read_valid_row_index(Size, RowIndex):-
    write('Row is out of bounds.\n'),
    read_valid_row_index(Size, RowIndex).


% read_valid_column_index(+Size, -ColumnIndex)
read_valid_column_index(Size, ColumnIndex):-
    read_letter(LetterCode),
    letter_code_to_index(LetterCode, ColumnIndex),
    MaxIndex is Size-1,
    number_between(ColumnIndex, 0, MaxIndex),
    !.
read_valid_column_index(Size, ColumnIndex):-
    write('Column is out of bounds.\n'),
    read_valid_column_index(Size, ColumnIndex).


% read_coords(+Size, -ColumnIndex, -RowIndex)
read_coords(Size, ColumnIndex, RowIndex):-
    write('Col ? '),
    read_valid_column_index(Size, ColumnIndex),
    write('Row ? '),
    read_valid_row_index(Size, RowIndex).


% read_move(+Size, -Move):-
read_move(Size, [[C1,L1], [C2,L2]]):-
    write('Insert source:\n'),
    read_coords(Size, C1, L1),
    write('Insert dest:\n'),
    read_coords(Size, C2, L2),
    !.

/*
% TODO remove once done
test_i:-
    write('Insert source coordinates:\n'),
    read_coords(8, C, R),
    nl,
    write(C),
    nl,
    write(R).
*/