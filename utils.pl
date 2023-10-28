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
