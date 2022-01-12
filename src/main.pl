:- consult('representation.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('logic.pl').
:- consult('bot.pl').
:- consult('utils.pl').
:- consult('textbeauty.pl').


% Players is [top, bot]
% PlayerType can be :   0 - human
%                       1 - ai difficulty level 1
%                       2 - ai difficulty level 2


% make_move(+GameState, +PlayerType, -NewGameState)
make_move([Turn|Board], 0, NewGameState):-
    length(Board, Size),
    read_move(Size, Move),
    move([Turn|Board], Move, NewGameState).
make_move([Turn|Board], PlayerType, NewGameState):-
    choose_move([Turn|Board], PlayerType, Move),
    move([Turn|Board], Move, NewGameState).


% get_player(+Turn, +Players, -PlayerType)
get_player(top, Players, PlayerType):-
    nth0(0, Players, PlayerType).
get_player(bot, Players, PlayerType):-
    nth0(1, Players, PlayerType).


% loop(+GameState, +Players)
loop([Turn|Board], Players):-
    repeat,
    get_player(Turn, Players, TurnPlayer),
    make_move([Turn|Board], TurnPlayer, NewGameState),
    display_game(NewGameState), 
    !, (
        (game_over(NewGameState, Winner), write(Winner), write(' WON!\n'));
        loop(NewGameState, Players)
    ).



/* MENU STUFF */

play_game:-
    read_player_types(Players),
    read_board_size(BoardSize),
    initial_state(BoardSize, GameState),
    display_game(GameState),
    !,
    loop(GameState, Players).


view_rules:-
    write('\n'),
    print_game_banner('RULES'),
    write('\n\nTODO put rules here\n'),
    write('enter - back\n\n'),
    skip_line.


quit_game:-
    write('Thanks for playing BREAKTHROUGH!\n').


error_handler:-
    write('Bad input, try again\n').


menu_option(1):-
    play_game, !.
menu_option(2):-
    view_rules, !.
menu_option(3):-
    quit_game, !.
menu_option(_):-
    error_handler.


menu_loop:-
    display_menu,
    read_number(Command),
    menu_option(Command),
    (
        Command == 3 ;
        menu_loop
    ).


% play
play :-
    display_logo,
    menu_loop.
