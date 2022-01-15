:- consult('representation.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('logic.pl').
:- consult('pc.pl').
:- consult('utils.pl').
:- consult('textbeauty.pl').


% Players is [top, bot]
% PlayerType can be :   0 - human
%                       1 - PC difficulty level 1
%                       2 - PC difficulty level 2


/*
    Given a PlayerType, performs a move transforming the given GameState into the NewGameState.
*/
% make_move(+GameState, +PlayerType, -NewGameState)
make_move(Turn-Board, 0, NewGameState):-
    length(Board, Size),
    repeat,
    read_move(Size, Move),
    move(Turn-Board, Move, NewGameState).
make_move(Turn-Board, PlayerType, NewTurn-NewBoard):-
    choose_move(Turn-Board, PlayerType, Move),
    % choose_move/3 already gets a validated Move, so there is no
    % need to use move/3 since it would be validated again
    do_valid_move(Board, Move, NewBoard),
    switch_turn(Turn, NewTurn).


/*
    Given the Players(Type) playing the game, gets the player of the given Turn.
*/
% get_player(+Turn, +Players, -PlayerType)
get_player(top, [PlayerTop, _PlayerBot], PlayerTop).
get_player(bot, [_PlayerTop, PlayerBot], PlayerBot).


/*
    Given a GameState and the type of players (Players) playing,
    performs the game loop.
*/
% game_loop(+GameState, +Players)
game_loop(GameState, _Players):-
    game_over(GameState, Winner), !,
    congratulate(Winner).
game_loop(Turn-Board, Players):-
    get_player(Turn, Players, TurnPlayer),
    make_move(Turn-Board, TurnPlayer, NewGameState),
    display_game(NewGameState), !,
    game_loop(NewGameState, Players).



/* MENU */

/*
    Gets player types and board size from input and starts the game loop.
*/
% play_game
play_game:-
    read_player_types(Players),
    read_board_size(BoardSize),
    initial_state(BoardSize, GameState),
    display_game(GameState),
    !,
    game_loop(GameState, Players).


/*
    Given a menu option performs the corresponding action.
    1 -> play game
    2 -> view game rules
    3 -> quit game
*/
% menu_option(+Option)
menu_option(1):-
    play_game, !.
menu_option(2):-
    view_rules, !.
menu_option(3):-
    quit_game, !.
menu_option(_):-
    error_handler.


/*
    Checks if a given Command corresponds to quit game and,
    if not, goes to the menu loop.
*/
% check_exit(+Command)
check_exit(3).
check_exit(_):-
    menu_loop.


/*
    Loop of the menu (display, input, action).
*/
% menu_loop
menu_loop:-
    display_menu,
    read_number(Command),
    menu_option(Command),
    check_exit(Command).


/*
    Main game predicate.
*/
% play
play:-
    display_logo,
    menu_loop.
