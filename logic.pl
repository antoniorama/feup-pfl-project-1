% Define a predicate to get the element at a specific position
element_at(Board, Pos, Element) :-
    Row is Pos // 10,
    Col is Pos mod 10,
    nth0(Row, Board, BoardRow),
    nth0(Col, BoardRow, Element).

% Define another predicate to check if the element is different from none
is_none(Board, Pos) :-
    element_at(Board, Pos, Element),
    Element = none.

test_fun:-
    board(_, Board),
    is_none(Board, 90).

% Checks if there is already a piece in those positions. use length. if start coordinates and end coordinates are diagonal it doesn't allow either
% canBePlayed(+Board, +StartPos, +View, +Direction, +Piece) :-

canBePlayed(Board, StartPos, light_player, horizontal, Piece) :-
    piece_info(Length, _, _, light_player, Piece),
    EndPos is StartPos + Length - 1,
    canBePlayedHelper(Board, StartPos, EndPos, light_player, horizontal).

canBePlayedHelper(_, StartPos, EndPos, _, _) :-
    StartPos > EndPos, !.
canBePlayedHelper(Board, StartPos, EndPos, _, _) :-
    StartPos =:= EndPos,
    is_none(Board, StartPos), !.
canBePlayedHelper(Board, StartPos, EndPos, light_player, horizontal) :-
    StartPos < EndPos,
    is_none(Board, StartPos),
    NextPos is StartPos + 1,
    canBePlayedHelper(Board, NextPos, EndPos, light_player, horizontal).


test_funfun:-
    board(_, Board),
    canBePlayed(Board, 98, light_player, horizontal, piece1_2).
    
% Base case: If the column index is out of range, succeed
line_all_none(_, Row, Col) :-
    Col >= 10, % assuming the board has 10 columns
    !.

% Recursive case: Check if the element at the current position is 'none'
% and then recursively check the next position
line_all_none(Board, Row, Col) :-
    Pos is Row * 10 + Col, % Calculate position based on row and column indices
    is_none(Board, Pos), % Check if the element at the current position is 'none'
    NextCol is Col + 1, % Move to the next column
    line_all_none(Board, Row, NextCol). % Recursively check the next position

% Define a predicate to check if all elements in a line are 'none'
% It initiates the recursion with a column index of 0
all_elements_in_line_none(Board, Row) :-
    line_all_none(Board, Row, 0).



% place_piece(+Board, +StartPos, +Direction, +View, +Piece, -NewBoard)
% Places a piece in the board
place_piece(StartPos, horizontal, light_player, Piece, NewBoard):-
    board(_, Board),
    % canBePlayed(Board, StartPos, Direction, Piece),
    StartX is StartPos // 10,
    StartY is StartPos mod 10,
    piece_info(NSquares, _, _, light_player, Piece),
    piece_default_square(Piece, DefaultSquare),
    format("Square Display: ~w  NSquares: ~d  StartX: ~d  StartY: ~d \n" ,[DefaultSquare, NSquares, StartX, StartY]),
    place_horizontal(Board, DefaultSquare, StartX, StartY, NSquares, NewBoard),
    display_board(NewBoard, 9, 10).

place_piece(Board, StartPos, horizontal, dark_player, Piece, NewBoard):-
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