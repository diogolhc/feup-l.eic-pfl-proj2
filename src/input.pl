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
    between(0, 9, Num), !,
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
    char_code('Z', ZUpperAscii), (
        between(ALowerAscii, ZLowerAscii, Code);
        between(AUpperAscii, ZUpperAscii, Code)
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
    between(ALowerAscii, ZLowerAscii, Code),
    Index is Code - ALowerAscii.
letter_code_to_index(Code, Index):- % upper case
    char_code('A', AUpperAscii),
    char_code('Z', ZUpperAscii),
    between(AUpperAscii, ZUpperAscii, Code),
    Index is Code - AUpperAscii.


% read_valid_row_index(+Size, -RowIndex) 
read_valid_row_index(Size, RowIndex):-
    read_number(RowNumber),
    RowIndex is Size - RowNumber,
    MaxIndex is Size-1,
    between(0, MaxIndex, RowIndex),
    !.
read_valid_row_index(Size, RowIndex):-
    write('Row is out of bounds.\n'),
    read_valid_row_index(Size, RowIndex).


% read_valid_column_index(+Size, -ColumnIndex)
read_valid_column_index(Size, ColumnIndex):-
    read_letter(LetterCode),
    letter_code_to_index(LetterCode, ColumnIndex),
    MaxIndex is Size-1,
    between(0, MaxIndex, ColumnIndex),
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


% valid_player(?Player)
valid_player(0).
valid_player(1).
valid_player(2).


% ask_for_player(-Player)
ask_for_player(Player):-
    write('Choose player type\n'),
    read_number(Player),
    valid_player(Player).
ask_for_player(Player):-
    write('Bad input, try again\n'),
    ask_for_player(Player).


% read_player_types(-Players)
read_player_types([Player1, Player2]):-
    write('Choose the type of each player:\n'),
    write('\t0 - human\n'),
    write('\t1 - PC level 1\n'),
    write('\t2 - PC level 2\n'),
    write('Player top:\n'),
    ask_for_player(Player1),
    write('Player bot:\n'),
    ask_for_player(Player2),
    write('Players configurated!\n').


% read_board_size(-BoardSize)
read_board_size(BoardSize):-
    write('Even integer in range 6-26\n'),
    read_number(BoardSize),
    even(BoardSize),
    between(6, 26, BoardSize).
read_board_size(BoardSize):-
    write('Bad input\n'),
    read_board_size(BoardSize).
