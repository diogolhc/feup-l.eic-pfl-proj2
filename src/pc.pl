:- use_module(library(random)).

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


% apply_tank_value_map(+TankList, -ValueList)
apply_tank_value_map([], []).

apply_tank_value_map([Tank | RestTanks], [Value | RestValues]):-
    tank_value_map(Tank, Value),
    apply_tank_value_map(RestTanks, RestValues).


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


% evaluate_lines(+Board, +Size, +Player, -Value)
evaluate_lines(_Board, 0, _Player, 0).

evaluate_lines(Board, Size, Player, Value):-  
    SizeLeft is Size - 1,
    Size > 0,
    evaluate_line(Board, SizeLeft, Player, CurrLineValue),
    evaluate_lines(Board, SizeLeft, Player, ValueAcc),
    Value is ValueAcc+CurrLineValue.


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


% best_move(+Move1, +Value1, +Move2, +Value2, -BestMove, -BestValue)
best_move(Move1, Value1, _Move2, Value2, Move1, Value1):-
    Value1 > Value2.
best_move(Move1, Value1, Move2, Value2, Move3, Value3):-
    Value1 == Value2, % TODO shouldn't this go to the prototype with same terms? eg.  best_move(Move1, Value12, Move2, Value12, Move3, Value3)
    random(0, 2, Res),
    MoveValueList = [[Move1, Value1], [Move2, Value2]],
    matrix_at(MoveValueList, [0, Res], Move3),
    matrix_at(MoveValueList, [1, Res], Value3).
best_move(_Move1, _Value1, Move2, Value2, Move2, Value2).


% highest_value_move(+GameState, +MoveList, -BestValue, -BestMove)
% TODO show error somehow?
highest_value_move(Turn-Board, [LastMove], LastMoveValue, LastMove):- 
    do_valid_move(Board, LastMove, ResultBoard),
    value(Turn-ResultBoard, Turn, LastMoveValue).
highest_value_move(Turn-Board, [CurrentMove | RestMoves], BestValue, BestMove):-
    do_valid_move(Board, CurrentMove, ResultBoard),
    value(Turn-ResultBoard, Turn, CurrentValue),
    highest_value_move(Turn-Board, RestMoves, NextValue, NextMove),
    best_move(CurrentMove, CurrentValue, NextMove, NextValue, BestMove, BestValue).

% TODO make more similar with example from theoretical class
% choose_move(+GameState, +Level, -Move)
choose_move(GameState, 2, Move):- 
    valid_moves(GameState, ValidMoves),
    highest_value_move(GameState, ValidMoves, _, Move).
choose_move(GameState, 1, Move):- 
    valid_moves(GameState, ValidMoves),
    length(ValidMoves, Size),
    random(0, Size, RandomIndex),
    nth0(RandomIndex, ValidMoves, Move).
