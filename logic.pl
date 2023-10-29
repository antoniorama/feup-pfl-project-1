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
    StartX is StartPos // 10,
    StartY is StartPos mod 10.

place_piece(Board, StartPos, Direction, View, Piece, NewBoard):-
    View = 'dark',
    canBePlayed(Board, StartPos, Direction, Piece),
    DarkPos is 99 - StartPos,
    StartX is DarkPos // 10,
    StartY is DarkPos mod 10.

% place_horizontal(+Matrix, +Value, +X, +Y, +Length, -NewMatrix)
% places a piece (group of squares) horinzontally in the board
place_horizontal(Matrix, Value, X, Y, Length, NewMatrix):-
    place_horizontal(Matrix, Value, X, Y, Length, 0, NewMatrix).

place_horizontal(Matrix, _, _, _, Length, Counter, Matrix):-
    Counter >= Length.

place_horizontal(Matrix, Value, X, Y, Length, Counter, NewMatrix):-
    Counter < Length,
    place_in_matrix(Matrix, X, Y, Value, TempMatrix),
    NewY is Y + 1,
    NewCounter is Counter + 1,
    place_horizontal(TempMatrix, Value, X, NewY, Length, NewCounter, NewMatrix).

test_place_horizontal:-
    board(_, Board),
    place_horizontal(Board, 'd2_', 4, 5, 5, NewMatrix),
    display_header_coords(10, 10),
    display_board(NewMatrix, 9, 10),
    display_footer_coords(10, 10).