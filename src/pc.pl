:- use_module(library(random)).

/*
    Converts a game piece (tank) into its evaluation value to be 
    used in the board evaluation
*/
% tank_value_map(+Tank, -Value)
tank_value_map(0, 0).
tank_value_map(1, 100).
tank_value_map(2, 150).
tank_value_map(3, 125).
tank_value_map(Negative, Val):-
    Negative < 0,
    Positive is -1 * Negative,
    tank_value_map(Positive, V1),
    Val is -1*V1.

/*
    Each tank in a list is replaced by its evaluation value
*/
% apply_tank_value_map(+TankList, -ValueList)
apply_tank_value_map([], []).
apply_tank_value_map([Tank | RestTanks], [Value | RestValues]):-
    tank_value_map(Tank, Value),
    apply_tank_value_map(RestTanks, RestValues).

/* 
    Evaluates a line of the board for either of the players
    First the enemy tanks of Player are filtered from the line,
    then all the tanks are replaced by their evaluation value
    and get multiplied by the distance factor, this distance factor
    is 2^n where n is the number of lines between the current line
    being evaluated and the line closest to the Player. After these
    opperations the value of the line is the sum of the resultant
    list
*/
% evaluate_line(+Board, +Line, +Player, -Value)
evaluate_line(Board, Line, bot, Value):-
    length(Board, Size),
    DistanceCovered is Size - Line,
    nth0(Line, Board, LineList),
    filter_negatives(LineList, FilteredList),
    apply_tank_value_map(FilteredList, ValueList),
    Multiplier is 2 ** DistanceCovered,
    list_multiply_scalar(Multiplier, ValueList, ScaledValues),
    sum_list(ScaledValues, Value).
evaluate_line(Board, Line, top, Value):-
    nth0(Line, Board, LineList),
    list_multiply_scalar(-1, LineList, NormalizedList),
    filter_negatives(NormalizedList, FilteredList),
    apply_tank_value_map(FilteredList, ValueList),
    DistanceCovered is Line + 1,
    Multiplier is 2 ** DistanceCovered,
    list_multiply_scalar(Multiplier, ValueList, ScaledValues),
    sum_list(ScaledValues, Value).

/*
    Evaluates all the lines of the board for a Player and
    adds them resulting in the evaluation of the board
    for a Player
*/
% evaluate_lines(+Board, +Size, +Player, -Value)
evaluate_lines(_Board, 0, _Player, 0).
evaluate_lines(Board, Size, Player, Value):-  
    SizeLeft is Size - 1,
    Size > 0,
    evaluate_line(Board, SizeLeft, Player, CurrLineValue),
    evaluate_lines(Board, SizeLeft, Player, ValueAcc),
    Value is ValueAcc+CurrLineValue.

/*
    Evaluates the current GameSate for a Player, the board
    is evaluated for both Players and result is the subtraction
    of the evaluation of the Board for the Given player by the
    evaluation of the Board of its opponent
*/
% param +Player is either top or bot (bot = bottom, not PC)
% value(+GameState, +Player, -Value)
value(_-Board, top, Value):-
    length(Board, BoardSize),
    evaluate_lines(Board, BoardSize, top, TopValue),
    evaluate_lines(Board, BoardSize, bot, BotValue),
    Value is TopValue - BotValue.
value(GameState, bot, Value):-
    value(GameState, top, Inverted),
    Value is -1*Inverted.

/*
    Compares two valid moves deciding which is the one that results
    in the best value. In case of a tie of them is randomly selected
    with 1/2 chance
*/
% best_move(+Move1, +Value1, +Move2, +Value2, -BestMove, -BestValue)
best_move(Move1, Value1, _Move2, Value2, Move1, Value1):-
    Value1 > Value2.
best_move(Move1, Value12, Move2, Value12, Move3, Value3):-
    random(0, 2, Res),
    MoveValueList = [[Move1, Value12], [Move2, Value12]],
    matrix_at(MoveValueList, [0, Res], Move3),
    matrix_at(MoveValueList, [1, Res], Value3).
best_move(_Move1, _Value1, Move2, Value12, Move2, Value12).

/*
    From a List of valid moves that can be done by a player, it
    simulates each of them in a copy of the board and then evaluates 
    these modified GameStates selecting the one that has the highest
    evaluation
*/
% highest_value_move(+GameState, +MoveList, -BestValue, -BestMove)
highest_value_move(Turn-Board, [LastMove], LastMoveValue, LastMove):- 
    do_valid_move(Board, LastMove, ResultBoard),
    value(Turn-ResultBoard, Turn, LastMoveValue).
highest_value_move(Turn-Board, [CurrentMove | RestMoves], BestValue, BestMove):-
    do_valid_move(Board, CurrentMove, ResultBoard),
    value(Turn-ResultBoard, Turn, CurrentValue),
    highest_value_move(Turn-Board, RestMoves, NextValue, NextMove),
    best_move(CurrentMove, CurrentValue, NextMove, NextValue, BestMove, BestValue).

/*
    Chooses a move to be done by the pc player while taking into
    account its level, if it's level 1 it selects a random move,
    if it's level 2 it selects the best move possible according
    to the evaluation method being used
*/
% choose_move(+GameState, +Level, -Move)
choose_move(GameState, 2, Move):- 
    valid_moves(GameState, ValidMoves),
    highest_value_move(GameState, ValidMoves, _, Move).
choose_move(GameState, 1, Move):-
    valid_moves(GameState, ValidMoves),
    random_select(Move, ValidMoves, _Rest).
