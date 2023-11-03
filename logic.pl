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

calculateEndPos(StartPos, horizontal, Piece, EndPos):-
    piece_info(Length, _, _, _, Piece),
    EndPos is StartPos + Length - 1.
    % EndPos // 10 =:= StartPos // 10,
    % EndPos =< 99,
    % EndPos >= 0.

calculateEndPos(StartPos, vertical, Piece, EndPos):-
    piece_info(Length, _, _, _, Piece),
    EndPos is StartPos - ( (Length - 1) * 10).
    % EndPos mod 10 =:= StartPos mod 10,
    % EndPos =< 99,
    % EndPos >= 0.

% isOutOfBounds(+StartPos, +EndPos, +Direction)
isOutOfBounds(StartPos, EndPos, horizontal):-
    EndPos // 10 =:= StartPos // 10,
    EndPos =< 99,
    EndPos >= 0.

isOutOfBounds(StartPos, EndPos, vertical):-
    EndPos mod 10 =:= StartPos mod 10,
    EndPos =< 99,
    EndPos >= 0.

% Checks if there is already a piece in those positions. use length. if start coordinates and end coordinates are diagonal it doesn't allow either
% canBePlayed(+Board, +StartPos, +View, +Direction, +Piece)
canBePlayed(Board, StartPos, Direction, Piece) :-
    % \+is_none(Board, StartPos),
    calculateEndPos(StartPos, Direction, Piece, EndPos),
    isOutOfBounds(StartPos, EndPos, Direction),
    canBePlayedHelper(Board, StartPos, EndPos, Direction).

%for horizontal pieces
canBePlayedHelper(_, StartPos, EndPos, horizontal) :-
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
canBePlayedHelper(_, StartPos, EndPos, vertical) :-
    StartPos < EndPos, !.
canBePlayedHelper(Board, StartPos, EndPos, vertical) :-
    StartPos > EndPos,
    is_none(Board, StartPos),
    NextPos is StartPos - 10,
    canBePlayedHelper(Board, NextPos, EndPos, vertical).

test_funfun:-
    board(_, Board),
    canBePlayed(Board, 65, vertical, piece2_1).

% firstElement(+PieceList, -Piece)
firstElement([Head|_], Head).

% canPlaceAPiece(+Board, +PieceList)
% tries to place smaller piece
canPlaceAPiece(Board, PieceList):-
    firstElement(PieceList, FirstPiece),
    StartPos is 0,
    EndPos is 99,
    canPlaceAPieceHelper(Board, StartPos, EndPos, FirstPiece).

% Check horizontal and vertical placement at the current position
canPlaceAPieceHelper(Board, StartPos, _, FirstPiece):-
    canBePlayed(Board, StartPos, horizontal, FirstPiece), !.
canPlaceAPieceHelper(Board, StartPos, _, FirstPiece):-
    canBePlayed(Board, StartPos, vertical, FirstPiece), !.

% Recursive case: proceed to next position if no placement has been made
canPlaceAPieceHelper(Board, StartPos, EndPos, FirstPiece):-
    StartPos < EndPos,
    NextPos is StartPos + 1,
    canPlaceAPieceHelper(Board, NextPos, EndPos, FirstPiece).

can_place_piece_test :-
    test_board(_, Board),
    canPlaceAPiece(Board, [piece2_1, piece2_1, piece2_1, piece2_1, piece3_1, piece3_1, piece3_1, piece4_1, piece4_1, piece6_1]).

% place_piece(+Board, +StartPos, +Direction, +Player, +Piece, -NewBoard)
% Places a piece in the board, StartPos is received in respective player's coords
place_piece(Board, StartPos, Direction, Player, Piece, NewBoard):-
    calculate_position(Player, StartPos, StartX, StartY),
    calculate_pos_to_pos(Player, StartPos, NewPos),
    canBePlayed(Board, NewPos, Direction, Piece),
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





%Scoring phase

% Remove a piece from the board.
%place function that puts nones here

% ----------------------------------------
% FEITO COM O COPILOT - pode n estar a dar
% ----------------------------------------

% calculateScoreUponRemoval(+Player, +Piece, +NumberIntersectedPieces, +NumberScoreCounters, -ScoreUponRemoval)
calculateScoreUponRemoval(Player, Piece, NumberIntersectedPieces, NumberScoreCounters, ScoreUponRemoval):-
    piece_info(_, Value, _, _, Piece),
    NumberScoreCounters > 0,
    ScoreUponRemoval is NumberIntersectedPieces * Value * (NumberScoreCounters * 2).

calculateScoreUponRemoval(Player, Piece, NumberIntersectedPieces, NumberScoreCounters, ScoreUponRemoval):-
    piece_info(_, Value, _, _, Piece),
    NumberScoreCounters =:= 0,
    ScoreUponRemoval is NumberIntersectedPieces * Value.

% PlacedPieces = [Piece, PosWhite, Direction]
% calculateNumberOfPiecesInRow(+Row, +Board, +PlacedPiecesLight, +PlacedPiecesDark, -NumPieces)
calculateNumberOfPiecesInRow(Row, Board, PlacedPiecesLight, PlacedPiecesDark, NumPieces):-
    calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, PlacedPiecesDark, 0, NumPieces).

calculateNumberOfPiecesInRowHelper(_, _, [], [], NumPieces, NumPieces):- !.
calculateNumberOfPiecesInRowHelper(Row, Board, [[Piece, Pos, Direction]|T], PlacedPiecesDark, Acc, NumPieces):-
    calculate_position(light_player, Pos, X, Y),
    X =:= Row,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, EndX, _),
    EndX =:= Row,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInRowHelper(Row, Board, T, PlacedPiecesDark, Acc1, NumPieces).

calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, [[Piece, Pos, Direction]|T], Acc, NumPieces):-
    calculate_position(dark_player, Pos, X, Y),
    X =:= Row,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(dark_player, EndPos, EndX, _),
    EndX =:= Row,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, T, Acc1, NumPieces).

calculateNumberOfPiecesInRowHelper(Row, Board, [_|T], PlacedPiecesDark, Acc, NumPieces):-
    calculateNumberOfPiecesInRowHelper(Row, Board, T, PlacedPiecesDark, Acc, NumPieces).

calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, [_|T], Acc, NumPieces):-
    calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, T, Acc, NumPieces).

% calculateNumberOfPiecesInColumn(+Column, +Board, +PlacedPiecesLight, +PlacedPiecesDark, -NumPieces)
calculateNumberOfPiecesInColumn(Column, Board, PlacedPiecesLight, PlacedPiecesDark, NumPieces):-
    calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, PlacedPiecesDark, 0, NumPieces).

calculateNumberOfPiecesInColumnHelper(_, _, [], [], NumPieces, NumPieces):- !.
calculateNumberOfPiecesInColumnHelper(Column, Board, [[Piece, Pos, Direction]|T], PlacedPiecesDark, Acc, NumPieces):-
    calculate_position(light_player, Pos, X, Y),
    Y =:= Column,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, _, EndY),
    EndY =:= Column,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInColumnHelper(Column, Board, T, PlacedPiecesDark, Acc1, NumPieces).

calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, [[Piece, Pos, Direction]|T], Acc, NumPieces):-
    calculate_position(dark_player, Pos, X, Y),
    Y =:= Column,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(dark_player, EndPos, _, EndY),
    EndY =:= Column,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, T, Acc1, NumPieces).

calculateNumberOfPiecesInColumnHelper(Column, Board, [_|T], PlacedPiecesDark, Acc, NumPieces):-
    calculateNumberOfPiecesInColumnHelper(Column, Board, T, PlacedPiecesDark, Acc, NumPieces).
    
calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, [_|T], Acc, NumPieces):-
    calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, T, Acc, NumPieces).

%PlaceScoreCounter(+Player)

% PlaceScoringPlayer(Player):-
      calculate_position(Player, 00, StartX, StartY),
    
    

