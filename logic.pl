% Define a predicate to get the element at a specific position
element_at(Board, Pos, Element) :-
    Row is Pos // 10,
    Col is Pos mod 10,
    nth0(Row, Board, BoardRow),
    nth0(Col, BoardRow, Element).

% Define another predicate to check if the element is different from none
is_none(Board, Pos) :-
element_at(Board, Pos, none).

test_fun:-
    board(_, Board),
    is_none(Board, 90).

% Checks if there is already a piece in those positions. use length. if start coordinates and end coordinates are diagonal it doesn't allow either
% canBePlayed(+Board, +StartPos, +View, +Direction, +Piece) :-

calculateEndPos(StartPos, horizontal, Piece, EndPos):-
    piece_info(Length, _, _, _, Piece),
    EndPos is StartPos + Length - 1.

calculateEndPos(StartPos, vertical, Piece, EndPos):-
    piece_info(Length, _, _, _, Piece),
    EndPos is StartPos + Length * 10 - 10.
    
canBePlayed(Board, StartPos, Direction, Piece) :-
    calculateEndPos(StartPos, Direction, Piece, EndPos),
    canBePlayedHelper(Board, StartPos, EndPos, Direction).

%for horizontal pieces
canBePlayedHelper(_, StartPos, EndPos, _) :-
    StartPos > EndPos, !.
canBePlayedHelper(Board, StartPos, EndPos, _) :-
    StartPos =:= EndPos,
    is_none(Board, StartPos), !.
canBePlayedHelper(Board, StartPos, EndPos, horizontal) :-
    StartPos < EndPos,
    is_none(Board, StartPos),
    NextPos is StartPos + 1,
    canBePlayedHelper(Board, NextPos, EndPos, horizontal).

%for vertical pieces
canBePlayedHelper(Board, StartPos, EndPos, vertical) :-
    StartPos < EndPos,
    is_none(Board, StartPos),
    NextPos is StartPos + 10,
    canBePlayedHelper(Board, NextPos, EndPos, vertical).

test_funfun:-
    board(_, Board),
    canBePlayed(Board, 98, horizontal, piece1_2).

firstElement([Head|_], Head).

%canPlaceAnyPiece(+Board, +PieceList)
%tries to place smaller piece
canPlaceAPiece(Board, light_player, PieceList):-
    firstElement(PieceList, firstPiece),
    piece_info(Length, _, _, _, firstPiece),
    StartPos is 90,
    EndPos is 09,
    canPlaceAPieceHelper(Board, light_player, StartPos, EndPos).

canPlaceAPieceHelper(Board, light_player, StartPos, EndPos):-
    calculate_position(light_player, StartPos, StartX, StartY),
    calculate_position(light_player, EndPos, EndX, EndY),
    StartX > EndX, !.
    StartY > EndY, !.
 
canPlaceAPieceHelper(Board, light_player, StartPos, EndPos):-
    calculate_position(light_player, StartPos, StartX, StartY),
    calculate_position(light_player, EndPos, EndX, EndY),
    StartX =:= EndX,
    StartY =:= EndY,
    canBePlayed(Board, StartPos, horizontal, Piece), !.

canPlaceAPieceHelper(Board, light_player, StartPos, EndPos):-
    calculate_position(light_player, StartPos, StartX, StartY),
    calculate_position(light_player, EndPos, EndX, EndY),
    StartX <= EndX,
    StartY <= EndY,
    NextPos is StartPos - 1,
    canBePlayed(Board, NextPos, vertical, Piece).
    

% place_piece(+Board, +StartPos, +Direction, +Player, +Piece, -NewBoard)
% Places a piece in the board
place_piece(Board, StartPos, Direction, Player, Piece, NewBoard):-
    canBePlayed(Board, StartPos, Direction, Piece),
    calculate_position(Player, StartPos, StartX, StartY),
    piece_info(NSquares, _, _, Player, Piece),
    piece_default_square(Piece, DefaultSquare),
    format("Square Display: ~w  NSquares: ~d  StartX: ~d  StartY: ~d \n" ,[DefaultSquare, NSquares, StartX, StartY]),
    place_direction(Board, DefaultSquare, StartX, StartY, NSquares, NewBoard, Direction).

test_place_piece:-
    board(_, Board),
    place_piece(Board, 85, vertical, light_player, piece1_2, NewBoard),
    display_header_coords(10, 10),
    display_board(NewBoard, 9, 10),
    display_footer_coords(10, 10).

place_direction(Matrix, Value, X, Y, Length, NewMatrix, horizontal):-
    place_horizontal(Matrix, Value, X, Y, Length, NewMatrix).

place_direction(Matrix, Value, X, Y, Length, NewMatrix, vertical):-
    place_vertical(Matrix, Value, X, Y, Length, NewMatrix).

% place_horizontal(+Matrix, +Value, +X, +Y, +Length, -NewMatrix)
% places a piece (group of squares) horinzontally in the board
place_horizontal(Matrix, _, _, _, 0, Matrix):- !.
place_horizontal(Matrix, Value, X, Y, Length, NewMatrix):-
    place_in_matrix(Matrix, X, Y, Value, TempMatrix),
    NewY is Y + 1,
    NewLength is Length - 1,
    place_horizontal(TempMatrix, Value, X, NewY, NewLength, NewMatrix).

% place_vertical(+Matrix, +Value, +X, +Y, +Length, -NewMatrix)
% places a piece (group of squares) vertically in the board
place_vertical(Matrix, _, _, _, 0, Matrix):- !.
place_vertical(Matrix, Value, X, Y, Length, NewMatrix):-
    place_in_matrix(Matrix, X, Y, Value, TempMatrix),
    NewX is X - 1,
    NewLength is Length - 1,
    place_vertical(TempMatrix, Value, NewX, Y, NewLength, NewMatrix).

test_place_horizontal:-
    board(_, Board),
    place_horizontal(Board, 'd2_', 4, 5, 5, NewMatrix),
    display_header_coords(10, 10),
    display_board(NewMatrix, 9, 10),
    display_footer_coords(10, 10).