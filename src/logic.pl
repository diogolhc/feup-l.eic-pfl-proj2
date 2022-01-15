:- use_module(library(lists)).
:- ensure_loaded('utils.pl').


%% TANK BOT is the standard TANK TYPE representation 
%% (numbers and possible translations)


/*
    Gets the standard tank type.
    bot tanks don't change (already positive)
    top tanks switch signal (negative to positive)
*/
% tank_type(+Tank, -TankType)
tank_type(Tank, TankType):-
    TankType is abs(Tank).


/*
    Gets valid standard tank translation when not attacking.
*/
% tank_bot_valid_translation(?[CT,LT])
tank_bot_valid_translation([-1, -1]).
tank_bot_valid_translation([ 0, -1]).
tank_bot_valid_translation([ 1, -1]).


/*
    Gets valid standard tank translation for a given tank type when attacking.
*/
% tank_bot_valid_destroy_translation(?TankType, ?[CT,LT])
tank_bot_valid_destroy_translation(_TankType, [0, -1]).
tank_bot_valid_destroy_translation(1, [-1, -1]).
tank_bot_valid_destroy_translation(1, [ 1, -1]).
tank_bot_valid_destroy_translation(2, [ 0, -2]).
tank_bot_valid_destroy_translation(2, [-1, -1]).
tank_bot_valid_destroy_translation(2, [ 1, -1]).
tank_bot_valid_destroy_translation(2, [-2, -2]).
tank_bot_valid_destroy_translation(2, [ 2, -2]).
tank_bot_valid_destroy_translation(3, [ 0, -2]).


/*
    Checks if a given tank belongs to a given player.
    If an empty space is given, it belongs to none.
*/
% player_tank(+Turn, +Tank)
is_player_tank(top, Tank):-
    Tank < 0.
is_player_tank(bot, Tank):-
    Tank > 0.


/*
    Performs an already validated Move transforming Board into NewBoard.
*/
% do_valid_move(+Board, +Move, -NewBoard)
do_valid_move(Board, [[C1,L1], [C2,L2]], NewBoard):-
    matrix_at(Board, [C1,L1], Tank),
    matrix_put_at(Board, [C1,L1], 0, TempBoard),
    matrix_put_at(TempBoard, [C2,L2], Tank, NewBoard).


/*
    Checks if a given translation, with a given destination element for a given standard tank is valid.
*/
% check_valid_translation(+Destination, +TankType, +[CT,LT])
check_valid_translation(0, _, [C,L]):-
    tank_bot_valid_translation([C,L]).
check_valid_translation(Destination, TankType, [C,L]):-
    Destination \= 0,
    tank_bot_valid_destroy_translation(TankType, [C,L]).
    

/*
    Given a turn (top or bot) and a given vertical movement, normalizes it into
    a standard vertical move.
*/
% uniform_move(+Turn, +VerticalMovement, -UniformVerticalMovement)
uniform_move(bot, _L, _L).
uniform_move(top, L1, L2):-
    L2 is -1*L1.


/*
    Given a GameState checks if a given Move is valid or
    gets a valid Move for a given GameState.
*/
% valid_move(+GameState, ?Move)
valid_move(Turn-Board, [[C1,L1], [C2,L2]]):-
    matrix_at(Board, [C1,L1], Tank),
    is_player_tank(Turn, Tank),
    matrix_at(Board, [C2,L2], Destination),
    sub_coordinates([C2,L2], [C1,L1], [C3,L3]),
    uniform_move(Turn, L3, L4),
    tank_type(Tank, TankType),
    not(is_player_tank(Turn, Destination)),
    check_valid_translation(Destination, TankType, [C3,L4]).
    

/*
    Switchs game turn.
*/
% switch_turn(?Turn, ?SwitchedTurn)
switch_turn(top, bot).
switch_turn(bot, top).


/*
    Given a GameState and a Move, checks if the Move is valid,
    and, if it is, perfoms it into the NewGameState.
*/
% move(+GameState, +Move, -NewGameState)
move(Turn-Board, Move, NewTurn-NewBoard):-
    valid_move(Turn-Board, Move),
    do_valid_move(Board, Move, NewBoard),
    switch_turn(Turn, NewTurn).


/*
    Given a GameState checks if the game has reached its end,
    and, if it has, gets the game Winner.
*/
% game_over(+GameState, -Winner)
game_over(_-Board, bot):-
    nth0(0, Board, TopRow),
    max_member(Max, TopRow),
    Max > 0.
game_over(_-Board, bot):-
    not(matrix_has_range(Board, negative)).
game_over(_-Board, top):-
    length(Board, Height),
    H1 is Height-1,
    nth0(H1, Board, BotRow),
    min_member(Min, BotRow),
    Min < 0.
game_over(_-Board, top):-
    not(matrix_has_range(Board, positive)).


/*
    Given a GameState, gets the list of all the valid moves.
*/
% valid_moves(+GameState, -ListOfMoves)
valid_moves(GameState, ListOfMoves):-
    findall(Move, valid_move(GameState, Move), ListOfMoves).
