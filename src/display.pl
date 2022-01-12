:- consult('textbeauty.pl').

% TODO maybe choose more distinguished chars:
% code(+Code, -BoardRepresentation)
code( 0, ' ').
code( 1, 'M').
code( 2, 'H').
code( 3, 'D').
code(-1, 'm').
code(-2, 'h').
code(-3, 'd').


% print_number(+Number)
print_number(Number):-
    Number > 9,
    write(Number).
print_number(Number):-
    Number < 10,
    write(' '),
    write(Number).


% print_upper_letter(+LetterOrder)
% 0 => 'A'
print_upper_letter(LetterOrder):-
    char_code('A', AUpperAscii),
    AsciiCode is AUpperAscii + LetterOrder,
    put_code(AsciiCode).


% print_left_padding
print_left_padding:-
    write('     ').


print_nav_horizontal(Size, Size):-
    nl,
    nl.
print_nav_horizontal(Size, Current):-
    write('  '),
    print_upper_letter(Current),
    write(' '),
    C1 is Current+1,
    print_nav_horizontal(Size, C1).


% print_nav_horizontal(+Size)
print_nav_horizontal(Size):-
    print_left_padding,
    print_nav_horizontal(Size, 0).


% print_board_horizontal_separator(+Size)
print_board_horizontal_separator(0):-
    write('+'),
    nl.
print_board_horizontal_separator(Size):-
    write('+---'),
    S1 is Size-1,
    print_board_horizontal_separator(S1).


% print_board_line(+Line, +Number)
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


% print_board(+Board, +Size, +CurrentLine)
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


% print_board(+Board)
print_board(Board):-
    nl,
    length(Board, Size),
    print_nav_horizontal(Size),
    print_board(Board, Size, Size),
    print_nav_horizontal(Size).


% display_game(+GameState)
display_game([Turn|Board]):-
    print_board(Board),
    write('Current player: '),
    write(Turn),
    nl.


display_logo :-
    write('  ____  _____  ______          _  _________ _    _ _____   ____  _    _  _____ _    _\n'),
    write(' |  _ \\|  __ \\|  ____|   /\\   | |/ /__   __| |  | |  __ \\ / __ \\| |  | |/ ____| |  | |\n'),
    write(' | |_) | |__) | |__     /  \\  | \' /   | |  | |__| | |__) | |  | | |  | | |  __| |__| |\n'),
    write(' |  _ <|  _  /|  __|   / /\\ \\ |  <    | |  |  __  |  _  /| |  | | |  | | | |_ |  __  |\n'),
    write(' | |_) | | \\ \\| |____ / ____ \\| . \\   | |  | |  | | | \\ \\| |__| | |__| | |__| | |  | |\n'),
    write(' |____/|_|  \\_\\______/_/    \\_\\_|\\_\\  |_|  |_|  |_|_|   \\_\\____/ \\____/ \\_____|_|  |_|\n').

display_menu :-
    write('\n\n'),
    print_game_banner('MAIN MENU'),
    write('\n\n'),
    write('1 - start game\n'),
    write('2 - rules\n'),
    write('3 - quit game\n'),
    write('\n').
