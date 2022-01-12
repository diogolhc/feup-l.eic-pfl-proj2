print_n(S, N) :-    N > 1,
                    put_char(S),
                    print_n(S, N-1).
print_n(S, N) :-    1 is N,
                    put_char(S).

print_text(Text, Symbol, Padding) :-    put_char(Symbol),
                                        print_n(' ', Padding),
                                        print(Text),
                                        print_n(' ', Padding),
                                        put_char(Symbol).

print_top_banner(Text, Symbol, Padding) :-  Y1 is Padding * 2,
                                            Y2 is Y1 + 2,
                                            atom_length(Text, X),
                                            Y3 is Y2 + X,
                                            print_n(Symbol, Y3).

print_mid_banner(Text, Symbol, Padding) :-  Y1 is Padding * 2,
                                            atom_length(Text, X),
                                            Y2 is Y1 + X,
                                            put_char(Symbol),
                                            print_n(' ', Y2),
                                            put_char(Symbol).

print_banner(Text, Symbol, Padding) :-  print_top_banner(Text, Symbol, Padding),
                                        put_char('\n'),
                                        print_mid_banner(Text, Symbol, Padding),
                                        put_char('\n'),
                                        print_text(Text, Symbol, Padding),
                                        put_char('\n'),
                                        print_mid_banner(Text, Symbol, Padding),
                                        put_char('\n'),
                                        print_top_banner(Text, Symbol, Padding).

print_game_banner(Text) :-
    atom_length(Text, TextSize),
    PaddingSize is div(86-TextSize, 2),
    print_banner(Text, '*', PaddingSize).

