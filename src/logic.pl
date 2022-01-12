:- use_module(library(lists)).
:- consult('utils.pl').
:- consult('display.pl'). % TODO remove after debug


%% TANK BOT is the standard TANK TYPE representation 
%% (numbers and possible translations)


% tank_type(+Tank, -TankType)
tank_type(Tank, TankType):-
    TankType is abs(Tank).


% tank_bot_valid_translation(?[CT,LT])
tank_bot_valid_translation([-1, -1]).
tank_bot_valid_translation([ 0, -1]).
tank_bot_valid_translation([ 1, -1]).


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


% player_tank(+Turn, +Tank)
is_player_tank(top, Tank):-
    Tank < 0.
is_player_tank(bot, Tank):-
    Tank > 0.


% Move must be valid
% do_valid_move(+Board, +Move, -NewBoard)
do_valid_move(Board, [[C1,L1], [C2,L2]], NewBoard):-
    matrix_at(Board, [C1,L1], Tank),
    matrix_put_at(Board, [C1,L1], 0, TempBoard),
    matrix_put_at(TempBoard, [C2,L2], Tank, NewBoard).


% check_valid_translation(+Destination, +TankType, +[CT,LT])
check_valid_translation(0, _, [C,L]):-
    tank_bot_valid_translation([C,L]).
check_valid_translation(Destination, TankType, [C,L]):-
    Destination \= 0,
    tank_bot_valid_destroy_translation(TankType, [C,L]).
    

% uniform_move(+Turn, +VerticalMovement, -UniformVerticalMovement)
uniform_move(bot, _L, _L).
uniform_move(top, L1, L2):-
    L2 is -1*L1.


% valid_move(+GameState, ?Move)
valid_move([Turn|Board], [[C1,L1], [C2,L2]]):-
    matrix_at(Board, [C1,L1], Tank),
    is_player_tank(Turn, Tank),
    matrix_at(Board, [C2,L2], Destination),
    sub_coordinates([C2,L2], [C1,L1], [C3,L3]),
    uniform_move(Turn, L3, L4),
    tank_type(Tank, TankType),
    not(is_player_tank(Turn, Destination)),
    check_valid_translation(Destination, TankType, [C3,L4]).
    

% switch_turn(?Turn, ?SwitchedTurn)
switch_turn(top, bot).
switch_turn(bot, top).


% move(+GameState, +Move, -NewGameState)
move([Turn|Board], Move, [NewTurn|NewBoard]):-
    valid_move([Turn|Board], Move),
    do_valid_move(Board, Move, NewBoard),
    switch_turn(Turn, NewTurn).


% game_over(+GameState, -Winner)
game_over([_|Board], bot):-
    nth0(0, Board, TopRow),
    max_member(Max, TopRow),
    Max > 0.
game_over([_|Board], top):-
    length(Board, Height),
    H1 is Height-1,
    nth0(H1, Board, BotRow),
    min_member(Min, BotRow),
    Min < 0.


% valid_moves(+GameState, -ListOfMoves)
valid_moves(GameState, ListOfMoves):-
    findall(Move, valid_move(GameState, Move), ListOfMoves).



% DEBUG ONLY:

get_initial_board([
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0,  0,  0,  0,  0,  0,  0,  0],
  [  0, -1,  0,  0,  0,  0,  0,  0],
  [  0, -1,  1,  0,  0,  0,  0,  0],
  [  0,  0,  0,  2,  0,  0,  0,  0]
]).

test_l:-
    get_initial_board(Board),
    append([top], Board, GameState),

    /*
    %trace,
    !,
    repeat,
    valid_move(GameState, [ [3,6], Dest]),
    write(Dest),
    fail.
    */

    /*
    valid_moves(GameState, ListOfMoves),
    write(ListOfMoves),
    length(ListOfMoves, S),
    nl,
    write(S).
    */

     
    display_game(GameState),
    !,
    move(GameState, [[1,5],[2,6]], NewGameState),
    display_game(NewGameState),
    !,
    game_over(NewGameState, Winner),
    write(Winner).
