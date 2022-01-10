:- consult('representation.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('logic.pl').
:- consult('bot.pl').
:- consult('utils.pl').

% Players is [top, bot]
% PlayerType can be :   0 - human
%                       1 - ai difficulty level 1
%                       2 - ai difficulty level 2

% make_move(+GameState, +PlayerType, -NewGameState)
make_move([Turn|Board], 0, NewGameState) :-
    length(Board, Size),
    read_move(Size, Move),
    move([Turn|Board], Move, NewGameState).
make_move([Turn|Board], PlayerType, NewGameState) :-
    choose_move([Turn|Board], PlayerType, Move),
    move([Turn|Board], Move, NewGameState).

% get_player(+Turn, +Players, -PlayerType)
get_player(top, Players, PlayerType) :- nth0(0, Players, PlayerType).
get_player(bot, Players, PlayerType) :- nth0(1, Players, PlayerType).

% loop(+GameState, +Players)
loop([Turn|Board], Players):-
    repeat,
    get_player(Turn, Players, TurnPlayer),
    make_move([Turn|Board], TurnPlayer, NewGameState),
    display_game(NewGameState), !, (
        (game_over(NewGameState, Winner), write(Winner), write(' WON!\n'));
        loop(NewGameState, Players)
    ).

% play
play:-
    % NOTE: preliminary version
    initial_state(8, GameState),
    display_game(GameState),
    !,
    loop(GameState, [0, 2]).
