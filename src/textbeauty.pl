/*
    Prints N times the S char.
*/
% print_n(+S, +N)
print_n(S, 1):-
    put_char(S).
print_n(S, N):-
    N > 1,
    put_char(S),
    N1 is N-1,
    print_n(S, N1).


/*
    Prints the given Text surrounded by space Padding and a Symbol on each side.
*/
% print_text(+Text, +Symbol, +Padding)
print_text(Text, Symbol, Padding):-
    put_char(Symbol),
    print_n(' ', Padding),
    print(Text),
    print_n(' ', Padding),
    put_char(Symbol).


/*
    Prints the top (and bot) part of the banner.
*/
% print_top_banner(+Text, +Symbol, +Padding)
print_top_banner(Text, Symbol, Padding):-
    Y1 is Padding * 2,
    Y2 is Y1 + 2,
    atom_length(Text, X),
    Y3 is Y2 + X,
    print_n(Symbol, Y3).


/*
    Prints the mid part of the banner.
*/
% print_mid_banner(+Text, +Symbol, +Padding)
print_mid_banner(Text, Symbol, Padding):-
    Y1 is Padding * 2,
    atom_length(Text, X),
    Y2 is Y1 + X,
    put_char(Symbol),
    print_n(' ', Y2),
    put_char(Symbol).


/*
    Prints a banner with given Text, border Symbol and space Padding.
*/
% print_banner(+Text, +Symbol, +Padding)
print_banner(Text, Symbol, Padding):-
    print_top_banner(Text, Symbol, Padding), nl,
    print_mid_banner(Text, Symbol, Padding), nl,
    print_text(Text, Symbol, Padding), nl,
    print_mid_banner(Text, Symbol, Padding), nl,
    print_top_banner(Text, Symbol, Padding).


/*
    Prints the game banner with the given Text.
*/
% print_game_banner(+Text)
print_game_banner(Text):-
    atom_length(Text, TextSize),
    PaddingSize is div(86-TextSize, 2),
    print_banner(Text, '*', PaddingSize).
