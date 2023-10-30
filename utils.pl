% place_in_matrix(+Matrix, +X, +Y, +NewValue, -NewMatrix)
% places / replaces NewValue in matrix in position (X,Y)
place_in_matrix(Matrix, X, Y, NewValue, NewMatrix):-
    nth0(X, Matrix, OldRow),
    place_in_list(OldRow, Y, NewValue, NewRow),
    place_in_list(Matrix, X, NewRow, NewMatrix).

% place_in_list(+List, +Index, +Value, -NewList)
% places / replaces Value in list in index X
place_in_list(List, Index, Value, NewList):-
    nth0(Index, List, _, Rest),
    nth0(Index, NewList, Value, Rest).

% calculate_position(+Player, +StartPos, -X, -Y)
calculate_position(light_player, StartPos, X, Y):- 
    X is StartPos // 10,
    Y is StartPos mod 10.

calculate_position(dark_player, StartPos, X, Y):- 
    DarkPos is 99 - StartPos,
    X is DarkPos // 10,
    Y is DarkPos mod 10.