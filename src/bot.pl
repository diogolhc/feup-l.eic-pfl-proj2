% tank_value_map(+Tank, -Value)

tank_value_map(0, 0).
tank_value_map(1, 100).
tank_value_map(2, 125).
tank_value_map(3, 150).
tank_value_map(Negative, Val) :-
    Negative < 0,
    Positive is -1 * Negative,
    tank_value_map(Positive, V1),
    Val is -1*V1.


% apply_tank_value_map(+TankList, -ValueList)

apply_tank_value_map([], []).

apply_tank_value_map([Tank | RestTanks], [Value | RestValues]) :-
    tank_value_map(Tank, Value),
    apply_tank_value_map(RestTanks, RestValues).

% evaluate_line(+Board, +Line, +Player, -Value)
    
evaluate_line(Board, Line, bot, Value) :-
    length(Board, Size),
    DistanceCovered is Size - Line,
    nth0(Line, Board, LineList),
    filter_negatives(LineList, FilteredList),
    apply_tank_value_map(FilteredList, ValueList),
    list_multiply_scalar(DistanceCovered, ValueList, ScaledValues),
    sum_list(ScaledValues, Value).

evaluate_line(Board, Line, top, Value) :-
    nth0(Line, Board, LineList),
    list_multiply_scalar(-1, LineList, NormalizedList),
    filter_negatives(NormalizedList, FilteredList),
    apply_tank_value_map(FilteredList, ValueList),
    list_multiply_scalar(Line + 1, ValueList, ScaledValues),
    sum_list(ScaledValues, Value).

% evaluate_lines(+Board, +Size, +Player, -Value)

evaluate_lines(_Board, 0, _Player, 0).

evaluate_lines(Board, Size, Player, Value) :-  
    SizeLeft is Size - 1,
    Size > 0,
    evaluate_line(Board, SizeLeft, Player, CurrLineValue),
    evaluate_lines(Board, SizeLeft, Player, ValueAcc),
    Value is ValueAcc+CurrLineValue.


% param +Player is either top or bot (bottom not ai)
% value(+GameState, +Player, -Value)
% TODO (note: GameState is not only the Board)

value([_|Board], top, Value) :-
    length(Board, BoardSize),
    evaluate_lines(Board, BoardSize, top, TopValue),
    evaluate_lines(Board, BoardSize, bot, BotValue),
    Value is TopValue - BotValue.
value(GameState, bot, Value) :-
    value(GameState, top, Inverted),
    Value is -1*Inverted.

% choose_move(+GameState, +Level, -Move)
% TODO (note: GameState is not only the Board)

custom_gamestate(GameState) :-
    GameState = [   top,
                    [  -1,  0,  0,  0,  0, -1],
                    [   0,  0,  0, -3,  0,  0],
                    [   0,  0,  0,  0,  0,  0],
                    [   0,  0,  0,  0,  0,  0],
                    [   0,  0,  0,  0,  0,  0],
                    [   0,  0,  0,  0,  0, -1]
                ].