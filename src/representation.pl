:- use_module(library(lists)).
:- consult('utils.pl').

% 0: empty
% 1: Medium Tank
% 2: Heavy Tank
% 3: Tank destroyer


% back_line(+Size, -BackLine)
back_line(Size, BackLine):-
    between(6, 26, Size),
    HalfNumDestroyers is (Size-4) // 2,
    num_line(3, HalfNumDestroyers, HalfDestroyers),
    append([1], HalfDestroyers, Temp1),
    append(Temp1, [2,2], Temp2),
    append(Temp2, HalfDestroyers, Temp3),
    append(Temp3, [1], BackLine).


% bot_player_rep(+Size, -Matrix)
bot_player_rep(Size, Matrix):-
    between(6, 26, Size),
    num_line(1, Size, AllOne),
    back_line(Size, BackLine),
    append([AllOne], [BackLine], Matrix).


% mirror_rep(+Matrix, -MirrorMatrix)
mirror_rep(Matrix, MirrorMatrix):-
    reverse(Matrix, TempMatrix),
    matrix_multiply_scalar(-1, TempMatrix, MirrorMatrix).


% get_initial_board(+Size, -Board)
get_initial_board(Size, Board):-
    between(6, 26, Size),
    even(Size),
    bot_player_rep(Size, MatrixBot),
    mirror_rep(MatrixBot, MatrixTop),
    Height is Size-4,
    num_matrix(0, Height, Size, ZeroMatrix),
    append(MatrixTop, ZeroMatrix, Temp),
    append(Temp, MatrixBot, Board).


% minimim Size = 6 and must be even
% initial_state(+Size, -GameState)
initial_state(Size, bot-Board):- % bot plays goes first                                     
    between(6, 26, Size),
    even(Size),
    get_initial_board(Size, Board).
