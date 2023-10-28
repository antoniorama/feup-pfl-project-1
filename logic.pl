% Define a predicate to get the element at a specific position
element_at(Board, Pos, Element) :-
    RowPart is Pos // 10,
    Row is 9 - RowPart,
    Col is Pos mod 10,
    nth0(Row, Board, BoardRow),
    nth0(Col, BoardRow, Element),
% Define another predicate to check if the element is different from none
is_not_none(Board, Pos) :-
    RowPart is Pos // 10,
    Row is 9 - RowPart,
    Col is Pos mod 10,
    element_at(Board, Pos, Element),
    Element \= none.

test_fun:-
    board(_, Board),
    is_not_none(Board, 92).
% Checks if there is already a piece in those positions. use length. if start coordinates and end coordinates are diagonal it doesn't allow either
% canBePlayed(+Board, +StartPos, +Direction, +Direction, Piece) :-

canBePlayed(Board, StartPos, View, Direction, Piece) :-
    get_piece(Board, StartPos, Piece),
    get_piece(Board, EndPos, Piece),
    is_diagonal(StartPos, EndPos),
    is_empty(Board, EndPos).

% place_piece(+Board, +StartPos, +Direction, +View, +Piece, -NewBoard)
% Places a piece in the board
place_piece(Board, StartPos, Direction, View, Piece, NewBoard):-
    View = 'light',
    canBePlayed(Board, StartPos, Direction, Piece),
    StartX is Start // 10,
    StartY is Start mod 10,

place_piece(Board, StartPos, Direction, View, Piece, NewBoard):-
    View = 'dark',
    canBePlayed(Board, StartPos, Direction, Piece),
    StartX is Start // 10,
    StartY is Start mod 10,

place_horizontal(Matrix, Value, )
