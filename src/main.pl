:- consult('representation.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('logic.pl').
:- consult('bot.pl').
:- consult('utils.pl').



loop([Turn|Board]):-
    length(Board, Size),

    repeat,
    read_move(Size, Move),
    move([Turn|Board], Move, NewGameState),
    display_game(NewGameState), !, (
        (game_over(NewGameState, Winner), write(Winner), write(' WON!\n'));
        loop(NewGameState)
    ).


% play
play:-
    % NOTE: preliminary version
    initial_state(8, GameState),
    display_game(GameState),
    !,
    loop(GameState).
