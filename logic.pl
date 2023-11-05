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

calculateEndPos(StartPos, vertical, Piece, EndPos):-
    piece_info(Length, _, _, _, Piece),
    EndPos is StartPos - ( (Length - 1) * 10).

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
% canBePlayed(+Board, +StartPos, +Direction, +Piece)
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
    format('PLAYER~w \n', [Player]),
    canBePlayed(Board, NewPos, Direction, Piece),
    write('a2\n'),
    piece_info(NSquares, _, _, Player, Piece),
    write('a3\n'),
    piece_default_square(Piece, DefaultSquare),
    write('a4\n'),
    format("Square Display: ~w  NSquares: ~d  StartX: ~d  StartY: ~d \n" ,[DefaultSquare, NSquares, StartX, StartY]),
    place_direction(Board, DefaultSquare, StartX, StartY, NSquares, NewBoard, Direction).

% remove_piece(+Board, +Piece, +PosWhite, +Player, +Direction, -NewBoard)
% Removes a piece from the board
remove_piece(Board, Piece, PosWhite, Player, Direction, NewBoard) :-
    piece_info(Length, _, _ , _, Piece),
    place_nones(Board, PosWhite, Length, Player, Direction, NewBoard).

% place_nones(+Board, +StartPos, +Length, +Player, +Direction, -NewBoard)
% Places nones in the board, StartPos is received in respective player's coords
place_nones(Board, StartPos, Length, Player, Direction, NewBoard):-
    calculate_position(Player, StartPos, StartX, StartY),
    place_direction(Board, none, StartX, StartY, Length, NewBoard, Direction).

test_place_piece:-
    board(_, Board),
    place_piece(Board, 85, vertical, light_player, piece1_2, NewBoard),
    display_header_coords(10, 10),
    display_board(NewBoard, 9, 10),
    display_footer_coords(10, 10).

test_place_nones:-
    test_board(_, Board),
    place_nones(Board, 40, 8, light_player, horizontal, NewBoard),
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
    place_horizontal(Board, 'd1_', 4, 5, 5, NewMatrix),
    write('a'),
    place_horizontal(NewMatrix, none, 4, 5, 5, Pngbaby),
    write('b'),
    print_list(NewMatrix),
    display_header_coords(10, 10),
    display_board(Pngbaby, 9, 10),
    display_footer_coords(10, 10).

% - Scoring phase -

% base case: empty list
apply_to_second_elements([], []).

% recursive case: apply the function to the second element of each sublist
apply_to_second_elements([[A, B, C] | Rest], [[A, NewB, C] | TransformedRest]) :-
    calculate_pos_to_pos(dark_player, B, NewB),
    apply_to_second_elements(Rest, TransformedRest).

% calculateScoreUponRemoval(+Piece, +NumPieces, +NumScoreCounters, -Score)
calculateScoreUponRemoval(Piece, NumPieces, NumScoreCounters, Score):-
    NumScoreCounters > 0,
    piece_info(_, Value, _, _, Piece),
    Score is NumPieces * Value * (NumScoreCounters * 2).

calculateScoreUponRemoval(Piece, NumPieces, NumScoreCounters, Score):-
    NumScoreCounters =:= 0,
    piece_info(_, Value, _, _, Piece),
    Score is NumPieces * Value.

% get_number_pieces(+Direciton, +PosWhite, +Board, +PlacedPiecesDark, +PlacedPiecesLight, -NumberPieces)
get_number_pieces(horizontal, PosWhite , Board, PlacedPiecesDark, PlacedPiecesLight, NumberPieces) :-
apply_to_second_elements(PlacedPiecesDark, ListConverted),
    calculate_position_new(light_player, PosWhite, _, Y),
    calculateNumberOfPiecesInRow(Y, Board, PlacedPiecesLight, ListConverted, NumberPieces).

get_number_pieces(vertical, PosWhite, Board, PlacedPiecesDark, PlacedPiecesLight, NumberPieces) :-
apply_to_second_elements(PlacedPiecesDark, ListConverted),
    calculate_position_new(light_player, PosWhite, X, _),
    calculateNumberOfPiecesInColumn(X, Board, PlacedPiecesLight, ListConverted, NumberPieces).

% PlacedPieces = [Piece, PosWhite, Direction]
% calculateNumberOfPiecesInRow(+Row, +Board, +PlacedPiecesLight, +PlacedPiecesDark, -NumPieces)
calculateNumberOfPiecesInRow(Row, Board, PlacedPiecesLight, PlacedPiecesDark, NumPieces):-
    calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, PlacedPiecesDark, 0, NumPieces).

calculateNumberOfPiecesInRowHelper(_, _, [], [], NumPieces, NumPieces):- !.
calculateNumberOfPiecesInRowHelper(Row, Board, [[Piece, Pos, Direction]|T], PlacedPiecesDark, Acc, NumPieces):-
    calculate_position(light_player, Pos, X, _),
    X =:= Row,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, EndX, _),
    EndX =:= Row,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInRowHelper(Row, Board, T, PlacedPiecesDark, Acc1, NumPieces).

calculateNumberOfPiecesInRowHelper(Row, Board, [[Piece, Pos, Direction]|T], PlacedPiecesDark, Acc, NumPieces):-
    calculate_position(light_player, Pos, X, _),
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, EndX, _),
    EndX =< Row, X >= Row,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInRowHelper(Row, Board, T, PlacedPiecesDark, Acc1, NumPieces).

calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, [[Piece, Pos, Direction]|T], Acc, NumPieces):-
    calculate_position(light_player, Pos, X, _),
    X =:= Row,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, EndX, _),
    EndX =:= Row,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, T, Acc1, NumPieces).

calculateNumberOfPiecesInRowHelper(Row, Board, PlacedPiecesLight, [[Piece, Pos, Direction]|T], Acc, NumPieces):-
    calculate_position(light_player, Pos, X, _),
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, EndX, _),
    EndX =< Row, X >= Row,
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
format('dPIECE FOUND : ~w , ~w , ~w \n\n', [Piece, Pos, Direction]),
    calculateNumberOfPiecesInColumnHelper(Column, Board, T, PlacedPiecesDark, Acc1, NumPieces).

calculateNumberOfPiecesInColumnHelper(Column, Board, [[Piece, Pos, Direction]|T], PlacedPiecesDark, Acc, NumPieces):-
    calculate_position(light_player, Pos, X, Y),
    Y =< Column,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, _, EndY),
    EndY >= Column,
    Acc1 is Acc + 1,
format('c PIECE FOUND : ~w , ~w , ~w \n\n', [Piece, Pos, Direction]),
    calculateNumberOfPiecesInColumnHelper(Column, Board, T, PlacedPiecesDark, Acc1, NumPieces).

calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, [[Piece, Pos, Direction]|T], Acc, NumPieces):-
    calculate_position(light_player, Pos, X, Y),
    Y =:= Column,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, _, EndY),
    EndY =:= Column,
    Acc1 is Acc + 1,
format('a PIECE FOUND : ~w , ~w , ~w \n\n', [Piece, Pos, Direction]),
    calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, T, Acc1, NumPieces).

calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, [[Piece, Pos, Direction]|T], Acc, NumPieces):-
    calculate_position(light_player, Pos, X, Y),
    Y =< Column,
    calculateEndPos(Pos, Direction, Piece, EndPos),
    calculate_position(light_player, EndPos, _, EndY),
    EndY >= Column,
    Acc1 is Acc + 1,
    calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, T, Acc1, NumPieces).

calculateNumberOfPiecesInColumnHelper(Column, Board, [_|T], PlacedPiecesDark, Acc, NumPieces):-
    calculateNumberOfPiecesInColumnHelper(Column, Board, T, PlacedPiecesDark, Acc, NumPieces).
    
calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, [_|T], Acc, NumPieces):-
    calculateNumberOfPiecesInColumnHelper(Column, Board, PlacedPiecesLight, T, Acc, NumPieces).

%PlaceScoreCounter(+Player)

% PlaceScoringPlayer(Player):-
%      calculate_position(Player, 00, StartX, StartY),

test_row :-
    test_board2(_, Board),
    calculateNumberOfPiecesInRow(3, Board, [[piece2_2, 35, horizontal], [piece1_2, 49, vertical]], [[piece1_1, 41, vertical], [piece1_1, 32, horizontal]], NumPieces),
    format('~w\n', [NumPieces]).

test_column :-
    test_board2(_, Board),
    calculateNumberOfPiecesInColumn(5, Board, [[piece2_2, 35, horizontal], [piece1_2, 65, vertical]], [[piece1_1, 25, vertical], [piece1_1, 95, horizontal]], NumPieces),
        format('~w\n', [NumPieces]).

%iterates over each square in row
%iterateSquaresInRow(+Row, +Board, -FinalScoreCounter)
countScoreCountersInRow(Row, Board, FinalScoreCounter):-
    countScoreCountersInRowHelper(Row, Board, 0, 0, FinalScoreCounter).

countScoreCountersInRowHelper(_, _, 10, ScoreCounter, ScoreCounter):- !.

countScoreCountersInRowHelper(Row, Board, Col, ScoreCounter, FinalScoreCounter):-
    Pos is Row * 10 + Col,
    element_at(Board, Pos, Element),
    square_info(_, _, none, Element),
    format('~w ', [Element]),
    NewCol is Col + 1,
    countScoreCountersInRowHelper(Row, Board, NewCol, ScoreCounter, FinalScoreCounter).

countScoreCountersInRowHelper(Row, Board, Col, ScoreCounter, FinalScoreCounter):-
    Pos is Row * 10 + Col,
    element_at(Board, Pos, Element),
    \+ square_info(_, _, none, Element),
    format('~w ', [Element]),
    NewCol is Col + 1,
    NewScoreCounter is ScoreCounter + 1,
    countScoreCountersInRowHelper(Row, Board, NewCol, NewScoreCounter, FinalScoreCounter).

test_countScoreCountersInRow:-
     test_board3(_, Board),
     countScoreCountersInRow(0, Board, FinalScoreCounter),
     format('Final Score Counter: ~w', [FinalScoreCounter]).

%finds the position of the score counters in the board
%findScoreCountersPositions(+Board, +Pos, -LightPos, -DarkPos, -FinalLightPos, -FinalDarkPos)
findScoreCountersPositions(Board, Pos, LightPos, DarkPos, FinalLightPos, FinalDarkPos):-
    element_at(Board, Pos, Element),
    square_info(_, _, none, Element),
    NewPos is Pos + 1,
    findScoreCountersPositions(Board, NewPos, LightPos, DarkPos, FinalLightPos, FinalDarkPos).

findScoreCountersPositions(Board, Pos, _, DarkPos, FinalLightPos, FinalDarkPos):-
    element_at(Board, Pos, Element),
    square_info(_, _, sc_light, Element),
    NewPos is Pos + 1,
    findScoreCountersPositions(Board, NewPos, Pos, DarkPos, FinalLightPos, FinalDarkPos).

findScoreCountersPositions(Board, Pos, LightPos, _, FinalLightPos, FinalDarkPos):-
    element_at(Board, Pos, Element),
    square_info(_, _, sc_dark, Element),
    NewPos is Pos + 1,
    findScoreCountersPositions(Board, NewPos, LightPos, Pos, FinalLightPos, FinalDarkPos).

findScoreCountersPositions(_, 100, LightPos, DarkPos, ConvertedLightPos, ConvertedDarkPos):- 
    calculate_position(light_player, LightPos, LightRow, LightColumn),
    calculate_position(dark_player, DarkPos, DarkRow, DarkColumn), 
    ConvertedLightRow is 90 - (LightRow * 10),
    ConvertedDarkRow is 90 - (DarkRow * 10),
    ConvertedLightPos is ConvertedLightRow + LightColumn,
    ConvertedDarkPos is ConvertedDarkRow + DarkColumn.


test_findScoreCountersPositions:-
    test_board3(_, Board),
    findScoreCountersPositions(Board, 0, _, _, LightPos, DarkPos),
    format('Light Position: ~w, Dark Position: ~w', [LightPos, DarkPos]).

%replaces the piece with the score counter on top by the piece without the score counter
%replacePieceWithScoreCounter(+Board, +Pos, -NewBoard)
rewritePieceInBoard(Board, Pos, NewBoard):-
    PlacementRow is 9 - Pos // 10,
    PlacementCol is Pos mod 10,
    Row is Pos // 10,
    format('Row: ~w\n', [Row]),
    Col is Pos mod 10,
    format('Col: ~w\n', [Col]),
    nth0(PlacementRow, Board, BoardRow),
    nth0(PlacementCol, BoardRow, Element),
    withOrWithoutCounter(Element, ElementWithoutScoreCounter),
    place_in_matrix(Board, PlacementRow, PlacementCol, ElementWithoutScoreCounter, NewBoard).

test_printBoard:-
    test_board3(_, Board),
    display_header_coords(10, 10),
    display_board(Board, 9, 10),
    display_footer_coords(10, 10).

test_rewritePieceInBoard:-
    test_board3(_, Board),
    rewritePieceInBoard(Board, 70, NewBoard),
    display_header_coords(10, 10),
    display_board(NewBoard, 9, 10),
    display_footer_coords(10, 10).

test_accessBoardRow:-
    test_board3(_, Board),
    nth0(2, Board, BoardRow),
    nth0(0, BoardRow, Element),
    format('Element: ~w\n', [Element]).

%predicate that positions the score counters in the bottom left corner and top right corner
%if there is already a piece in the square ex l1_, replace it by l1s or l1S, depending on the color s or S of the score counter.
%placeScoreCounterLightInitial(+Board, -NewBoard)
placeScoreCounterLightInitial(Board, NewBoard):-
    element_at(Board, 0, none),
    place_in_matrix(Board, 0, 0, slight, NewBoard).

placeScoreCounterLightInitial(Board, NewBoard):-
    element_at(Board, 0, Element),
    format('Element: ~w\n', [Element]),
    withOrWithoutCounterLight(ElementWithScoreCounter, Element),
    format('ElementWithScoreCounter: ~w\n', [ElementWithScoreCounter]),
    place_in_matrix(Board, 0, 0, ElementWithScoreCounter, NewBoard).

placeScoreCounterDarkInitial(Board, NewBoard):-
    element_at(Board, 99, none),
    place_in_matrix(Board, 9, 9, sdark, NewBoard).

placeScoreCounterDarkInitial(Board, NewBoard):-
    element_at(Board, 99, Element),
    format('Element: ~w\n', [Element]),
    withOrWithoutCounterDark(ElementWithScoreCounter, Element),
    format('ElementWithScoreCounter: ~w\n', [ElementWithScoreCounter]),
    place_in_matrix(Board, 9, 9, ElementWithScoreCounter, NewBoard).

test_placeSC:-
    test_board3(_, Board),
    placeScoreCounterDarkInitial(Board, IntermediateBoard),
    placeScoreCounterLightInitial(IntermediateBoard, NewBoard),
    display_header_coords(10, 10),
    display_board(NewBoard, 9, 10), % Display the board after both counters have been placed
    display_footer_coords(10, 10).

%predicate that positions the score counters in the requested position
%placeScoreCounterLight(+Board, +Pos, -NewBoard)
placeScoreCounterLight(Board, Pos, NewBoard):-
    element_at(Board, Pos, none),
    Row is Pos // 10,
    Col is Pos mod 10,
    format('Row: ~w\n', [Row]),
    place_in_matrix(Board, Row, Col, slight, NewBoard).
    
placeScoreCounterLight(Board, Pos, NewBoard):-
    element_at(Board, Pos, Element),
    format('Element: ~w\n', [Element]),
    Row is Pos // 10,
    Col is Pos mod 10,
    withOrWithoutCounterLight(ElementWithScoreCounter, Element),
    format('ElementWithScoreCounter: ~w\n', [ElementWithScoreCounter]),
    place_in_matrix(Board, Row, Col, ElementWithScoreCounter, NewBoard).

placeScoreCounterDark(Board, Pos, NewBoard):-
    element_at(Board, Pos, none),
    Row is Pos // 10,
    Col is Pos mod 10,
    place_in_matrix(Board, Row, Col, sdark, NewBoard).

placeScoreCounterDark(Board, Pos, NewBoard):-
    element_at(Board, Pos, Element),
    format('Element: ~w\n', [Element]),
    Row is Pos // 10,
    Col is Pos mod 10,
    withOrWithoutCounterDark(ElementWithScoreCounter, Element),
    format('ElementWithScoreCounter: ~w\n', [ElementWithScoreCounter]),
    place_in_matrix(Board, Row, Col, ElementWithScoreCounter, NewBoard).

test_placeSC2:-
    test_board3(_, Board),
    placeScoreCounterLight(Board, 10, IntermediateBoard), % Apply the light counter
    placeScoreCounterDark(IntermediateBoard, 53, NewBoard),
    display_header_coords(10, 10),
    display_board(NewBoard, 9, 10), % Display the board after both counters have been placed
    display_footer_coords(10, 10).


%predicate that updates Score Counter's position on the board based on the score of the player
%updateScoreCounter(+ScoreLight, +ScoreDark, +Board,  -NewBoard)

updateScoreCounter(ScoreLight, ScoreDark, Board, NewBoard):-
    findScoreCountersPositions(Board, 0, _, _, LightPos, DarkPos),

    rewritePieceInBoard(Board, LightPos, IntermediateBoard1),         % Remove the old light score counter
    rewritePieceInBoard(IntermediateBoard1, DarkPos, IntermediateBoard2), % Remove the old dark score counter
    placeScoreCounterLight(IntermediateBoard2, ScoreLight, IntermediateBoard3),   % Place the new light score counter
    calculate_position(dark_player, ScoreDark, ScoreRow, ScoreColumn),
    ConvertedScoreDark is ScoreRow * 10 + ScoreColumn,
    placeScoreCounterDark(IntermediateBoard3, ConvertedScoreDark, NewBoard).   % Place the new dark score counter


test_updateScoreCounter:-
    test_board3(_, Board),
    updateScoreCounter(51, 46, Board, NewBoard),
    display_header_coords(10, 10),
    display_board(NewBoard, 9, 10), % Display the board after both counters have been placed
    display_footer_coords(10, 10).


%The minimax algorithm should be used in the scoring phase. Players would aim to maximize their scores while minimizing the potential scoring of the opponent.
% Base case of recursion: if the game is over, evaluate the utility of the board
% minimax(+Position, +Depth, +Player, -Utility, -Move)
minimax(Position, _, Player, Utility, []) :-
    game_over(Position),
    !,
    evaluate(Position, Player, Utility).

% Recursive case: if the game is not over, and it is the maximizer's turn
% minimax(+Position, +Depth, +Player, -Utility, -Move)
minimax(Position, Depth, maximizer, BestUtility, BestMove) :-
    Depth > 0,
    valid_moves(Position, maximizer, Moves),
    NewDepth is Depth - 1,
    find_best_move(Moves, NewDepth, maximizer, -inf, [], BestUtility, BestMove).

% Recursive case: if the game is not over, and it is the minimizer's turn
% minimax(+Position, +Depth, +Player, -Utility, -Move)
minimax(Position, Depth, minimizer, BestUtility, BestMove) :-
    Depth > 0,
    valid_moves(Position, minimizer, Moves),
    NewDepth is Depth - 1,
    find_best_move(Moves, NewDepth, minimizer, inf, [], BestUtility, BestMove).

% Evaluate a list of moves and find the best one, updating the best utility found so far
% find_best_move(+Moves, +Depth, +Player, +CurrentBestUtility, +CurrentBestMove, -BestUtility, -BestMove)
find_best_move([], _, _, BestUtility, BestMove, BestUtility, BestMove).
find_best_move([Move|Moves], Depth, Player, CurrentBestUtility, CurrentBestMove, BestUtility, BestMove) :-
    move(Position, Move, NewPosition),
    switch_player(Player, NextPlayer),
    minimax(NewPosition, Depth, NextPlayer, Utility, _),
    update_best_utility(Utility, Move, Player, CurrentBestUtility, CurrentBestMove, NewCurrentBestUtility, NewCurrentBestMove),
    find_best_move(Moves, Depth, Player, NewCurrentBestUtility, NewCurrentBestMove, BestUtility, BestMove).

% Update the best utility found so far for maximizer
update_best_utility(Utility, Move, maximizer, CurrentBestUtility, _, Utility, Move) :-
    greater_than(Utility, CurrentBestUtility).
update_best_utility(Utility, Move, maximizer, BestUtility, BestMove, BestUtility, BestMove) :-
    not_greater_than(Utility, BestUtility).

% Update the best utility found so far for minimizer
update_best_utility(Utility, Move, minimizer, CurrentBestUtility, _, Utility, Move) :-
    less_than(Utility, CurrentBestUtility).
update_best_utility(Utility, Move, minimizer, BestUtility, BestMove, BestUtility, BestMove) :-
    not_less_than(Utility, BestUtility).

% Helper predicates to compare utilities without using = or ==
greater_than(Utility, CurrentBestUtility) :-
    Utility > CurrentBestUtility.
not_greater_than(Utility, BestUtility) :-
    Utility =< BestUtility.

less_than(Utility, CurrentBestUtility) :-
    Utility < CurrentBestUtility.
not_less_than(Utility, BestUtility) :-
    Utility >= BestUtility.

% Switch player helper
switch_player(maximizer, minimizer).
switch_player(minimizer, maximizer).

% Game-specific predicates that need to be defined:
% game_over(Position) - Determines if the game is over.
% valid_moves(Position, Player, Moves) - Generates a list of valid moves for the player.
% move(Position, Move, NewPosition) - Applies a move to a position.
% evaluate(Position, Player, Utility) - Evaluates the position for a player.


% choose_move(+GameState, +Player, +Level, -Move)
choose_move(GameState, Player, 1, Move) :-
    % For Level 1, select a random move
    valid_moves(GameState, Player, Moves),
    random_member(Move, Moves).

choose_move(GameState, Player, 2, Move) :-
    % For Level 2, use the minimax algorithm to select the best move
    determine_depth(Level, Depth), % You need to define how you determine the depth based on level or other factors
    minimax(GameState, Depth, Player, Utility-Move).
