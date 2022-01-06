:- use_module(library(lists)). % TODO can we use this?
:- consult('utils.pl').

% 0: empty
% 1: Medium Tank
% 2: Heavy Tank
% 3: Tank destroyer

/*
% TODO remove once done
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
*/

% back_line(+Size, -BackLine)
back_line(Size, BackLine):-
    number_between(Size, 6, 26),
    HalfNumDestroyers is (Size-4) // 2,
    num_line(3, HalfNumDestroyers, HalfDestroyers),
    append([1], HalfDestroyers, Temp1),
    append(Temp1, [2,2], Temp2),
    append(Temp2, HalfDestroyers, Temp3),
    append(Temp3, [1], BackLine).


% bot_player_rep(+Size, -Matrix)
bot_player_rep(Size, Matrix):-
    number_between(Size, 6, 26),
    num_line(1, Size, AllOne),
    back_line(Size, BackLine),
    append([AllOne], [BackLine], Matrix).


% mirror_rep(+Matrix, -MirrorMatrix)
mirror_rep(Matrix, MirrorMatrix):-
    reverse(Matrix, TempMatrix),
    matrix_multiply_scalar(-1, TempMatrix, MirrorMatrix).


% get_initial_board(+Size, -Board)
get_initial_board(Size, Board):-
    number_between(Size, 6, 26),
    even(Size),
    bot_player_rep(Size, MatrixBot),
    mirror_rep(MatrixBot, MatrixTop),
    Height is Size-4,
    num_matrix(0, Height, Size, ZeroMatrix),
    append(MatrixTop, ZeroMatrix, Temp),
    append(Temp, MatrixBot, Board).


% tank_type(+Number, -Type)
tank_type(Number, Type):-
    Type is abs(Number).


% minimim Size = 6 and must be even
% initial_state(+Size, -GameState)
initial_state(Size, GameState):-
    number_between(Size, 6, 26),
    even(Size),
    get_initial_board(Size, Board),
    GameState is [bot, Board]. % bot plays first
