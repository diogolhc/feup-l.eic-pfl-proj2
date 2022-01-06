get_initial_board([
  [ -1, -3, -3, -2, -2, -3, -3, -1],
  [ -1, -1, -1, -1, -1, -1, -1, -1],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  1,  1,  1,  1,  1,  1,  1,  1],
  [  1,  3,  3,  2,  2,  3,  3,  1]
]).


% 0: space
% 1: Medium Tank
% 2: Heavy Tank
% 3: Tank destroyer

% TODO maybe choose more distinguished chars:
code( 0, ' ').
code( 1, 'M').
code( 2, 'H').
code( 3, 'D').
code(-1, 'm').
code(-2, 'h').
code(-3, 'd').

% 0 => '0'
print_number(Number):-
    AsciiCode is 48+Number, % 48 = '0' ASCII code
    put_code(AsciiCode).

% 0 => 'A'
print_upper_letter(LetterOrder):-
    AsciiCode is 65+LetterOrder, % 65 = 'A' ASCII code
    put_code(AsciiCode).

print_left_padding:-
    write('    ').

print_nav_horizontal(Size, Size):-
    nl,
    nl.
print_nav_horizontal(Size, Current):-
    write('  '),
    print_upper_letter(Current),
    write(' '),
    C1 is Current+1,
    print_nav_horizontal(Size, C1).


print_nav_horizontal(Size):-
    print_left_padding,
    print_nav_horizontal(Size, 0).


print_board_horizontal_separator(0):-
    write('+'),
    nl.
print_board_horizontal_separator(Size):-
    write('+---'),
    S1 is Size-1,
    print_board_horizontal_separator(S1).


print_board_line([], Number):-
    write('|  '),
    print_number(Number),
    nl.
print_board_line([H|T], Number):-
    code(H, C),
    write('| '),
    write(C),
    write(' '),
    print_board_line(T, Number).


print_board([], Size, 0):-
    print_left_padding,
    print_board_horizontal_separator(Size),
    nl.
print_board([H|T], Size, CurrentLine):-
    print_left_padding,
    print_board_horizontal_separator(Size),
    write(' '),
    print_number(CurrentLine),
    write('  '),
    print_board_line(H, CurrentLine),
    C1 is CurrentLine-1,
    print_board(T, Size, C1).


% USE THIS OUTSIDE THIS MODULE
print_game(Board):-
    nl,
    length(Board, Size),
    print_nav_horizontal(Size),
    print_board(Board, Size, Size),
    print_nav_horizontal(Size).


% TODO remove once done
test:-
    get_initial_board(Board),
    print_game(Board).
