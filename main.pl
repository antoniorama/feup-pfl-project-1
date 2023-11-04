:- consult(data).
:- consult(logic).
:- consult(utils).
:- consult(display).

% start_game initiates the game loop with an initial game state
play :-
    % initial_state(State),
		test_placement_phase_state(State), % just to test
    game_loop(State).

% initial_state(-State)
% initialize the state with turn to dark_player (0) and placement phase pieces
initial_state([0, [PlacementPhasePiecesDark, [], 0, 0], [PlacementPhasePiecesLight, [], 0, 0], Board]) :-
	test_board2(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).

% just a state to test placement phase
test_placement_phase_state([3, [_, [[piece2_1, 09, horizontal],[piece1_1, 29, horizontal],[piece1_1, 13, horizontal],[piece1_1, 38, horizontal],[piece2_1, 33, horizontal],[piece1_1, 57, vertical],[piece2_1, 53, horizontal],[piece3_1, 99, horizontal],[piece2_1, 94, horizontal]], 0, 7], [_,[[piece6_2, 12, horizontal],[piece4_2, 23, horizontal],[piece1_2, 30, vertical],[piece4_2, 33, horizontal],[piece1_2, 39, vertical],[piece1_2, 43, horizontal],[piece2_2, 56, horizontal],[piece1_2, 60, vertical],[piece2_2, 76, horizontal],[piece2_2, 80, horizontal],[piece3_2, 94, vertical],[piece3_2, 95, vertical],[piece2_2, 96, horizontal]],5,7],Board]) :- 
	test_board2(_, Board).

% game_loop(+State)
game_loop(State) :-
	retrieve_turn_from_state(State, TurnNO),
	turn_phase(TurnNO, placement_phase),
	next_phase(State), !, 
	write('Placement phase ends'), nl,
	display_game(State),
	build_scoring_phase_state(State, NewState),
	game_loop(NewState).

game_loop(State) :-
    % Display the current state of the game
    display_game(State),
    
		repeat,
    % Get the current player’s move
    choose_move(State, Move),
  
    % Update the game state based on the move
    move(State, Move, NewState), !,
    
    % Continue the game loop with the new state
    game_loop(NewState).

% display_turn(+TurnoNO)
display_turn(TurnNO) :-
	player_turn(PlayerName, TurnNO),
	format('~w , it is your turn\n\n\n', [PlayerName]).

show_player_piece(Piece):-
	piece_info(N_Squares, Value, _, _, Piece),
	format('~w | squares: ~w value: ~w \n\n', [Piece, N_Squares, Value]).

show_placed_piece_info([Piece, PosWhite, Direction], Index):-
	piece_info(N_Squares, Value, _, _, Piece),
	format('~w ) ~w | pos (white for now): ~w direction: ~w length: ~w\n\n', [Index, Piece, PosWhite, Direction, N_Squares]).

show_player_pieces(State) :-
  player_pieces(State, List),
	retrieve_turn_from_state(State, TurnNO),
  show_all_player_pieces(List, TurnNO, 1).

% Retrieves the list of pieces for the current player based on the state
player_pieces([0, [Pieces, _, _, _], _, _], Pieces).
player_pieces([1, _, [Pieces, _, _, _], _], Pieces).
player_pieces([2, [_, PlacedPiecesInfo, _, _], _, _], PlacedPiecesInfo).
player_pieces([3, _, [_, PlacedPiecesInfo, _, _], _], PlacedPiecesInfo).

% Helper predicate to show all pieces from the list
show_all_player_pieces([], _, _). % Base case: no more pieces to show
show_all_player_pieces([Piece | RestPieces], TurnNO, _) :-
	turn_phase(TurnNO, placement_phase),
  show_player_piece(Piece),
  show_all_player_pieces(RestPieces, TurnNO, _).

% Info : [Piece, PosWhite, Direction]
show_all_player_pieces([Info | RestPieces], TurnNO, Index) :-
	turn_phase(TurnNO, scoring_phase),
	show_placed_piece_info(Info, Index),
	NextIndex is Index + 1,
	show_all_player_pieces(RestPieces, TurnNO, NextIndex).

% show_scores(+State)
show_scores([_, [_,_,ScoreDark, PieceRemovedLenghtDark], [_,_,ScoreLight, PieceRemovedLenghtLight], _]) :-
	format('Dark Player - Score : ~w PieceRemovedLength : ~w\n', [ScoreDark, PieceRemovedLenghtDark]),
	format('Light Player - Score : ~w PieceRemovedLength : ~w\n\n', [ScoreLight, PieceRemovedLenghtLight]).

% TODO : This predicate could probably be made more concise (for human player)
% choose_move(+State, -Move)
% Gets the move by user input (for placement phase)
choose_move(State, [UserInputPiece, UserInputSquare, UserInputDirection]) :-
	retrieve_turn_from_state(State, TurnNO),
	turn_phase(TurnNO, placement_phase),
	write('Your pieces: \n\n'),
	show_player_pieces(State),
	write('Piece to place: '),
	read(UserInputPiece),
	clear_buffer,
	write('Square to place (ex: 04 or 54): '),
	read_number(UserInputSquare),
	write('Direction to place (horizontal or vertical): '),
	read(UserInputDirection),
	clear_buffer.

% Gets the move by user input (for scoring phase)
choose_move(State, Move) :-
	retrieve_turn_from_state(State, TurnNO),
	turn_phase(TurnNO, scoring_phase),
	show_scores(State),
	write('Placed pieces: \n\n'),
	show_player_pieces(State),
	write('Piece to remove: '),
	read_number(UserInput),
	get_move_from_placed_list(State, UserInput, Move),
	validate_move(State, Move).

% get_move_from_placed_list(+State, +Index, -Move)
get_move_from_placed_list([2, [_, PlacedPiecesDark, _, _], _, _], Index, Move) :-
	nth1(Index, PlacedPiecesDark, Move).

get_move_from_placed_list([3, _, [_, PlacedPiecesLight, _, _], _], Index, Move) :-
	nth1(Index, PlacedPiecesLight, Move).

% validate_moves(+State, +Move)
% validates a move
validate_move([2 ,[_, PlacedPiecesDark, _, _], [_, _, _, _], Board], Move) :-
	member(Move, PlacedPiecesDark).

validate_move([3 ,[_, _, _, _], [_, PlacedPiecesLight, _, _], Board], Move) :-
	member(Move, PlacedPiecesLight).

% Clause for when canPlaceAPiece succeeds for light_player
get_new_state([0, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [1, [NewList, NewPlayedPiecesList, 0, 0], [PlacementPhasePiecesLight, PlacedPiecesLight, 0, 0], NewBoard]) :-
    delete_element_from_list(PlayedPiece, PlacementPhasePiecesDark, NewList),
		append([[PlayedPiece, Square, Direction]], PlacedPiecesDark, NewPlayedPiecesList),
    canPlaceAPiece(NewBoard, PlacementPhasePiecesLight).

% Clause for when canPlaceAPiece fails for light_player
get_new_state([0, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [0, [NewList, NewPlayedPiecesList, 0, 0], [PlacementPhasePiecesLight, PlacedPiecesLight, 0, 0], NewBoard]) :-
    delete_element_from_list(PlayedPiece, PlacementPhasePiecesDark, NewList),
		append([[PlayedPiece, Square, Direction]], PlacedPiecesDark, NewPlayedPiecesList),
    \+ canPlaceAPiece(NewBoard, PlacementPhasePiecesLight).

% Clause for when canPlaceAPiece succeeds for dark_player
get_new_state([1, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [0, [PlacementPhasePiecesDark, PlacedPiecesDark, 0, 0], [NewList, NewPlayedPiecesList, 0, 0], NewBoard]) :-
	delete_element_from_list(PlayedPiece, PlacementPhasePiecesLight, NewList),
	append([[PlayedPiece, Square, Direction]], PlacedPiecesLight, NewPlayedPiecesList),
	canPlaceAPiece(NewBoard, PlacementPhasePiecesDark).

% Clause for when canPlaceAPiece fails for dark_player
get_new_state([1, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [1, [PlacementPhasePiecesDark, PlacedPiecesDark, 0, 0], [NewList, NewPlayedPiecesList, 0, 0], NewBoard]) :-
	delete_element_from_list(PlayedPiece, PlacementPhasePiecesLight, NewList),
	append([[PlayedPiece, Square, Direction]], PlacedPiecesLight, NewPlayedPiecesList),
	\+ canPlaceAPiece(NewBoard, PlacementPhasePiecesDark).

get_new_state([2, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], PlayedPiece, Square, Direction, NewBoard, [3, [PlacementPhasePiecesDark, NewList, NewScore, NewPieceRemovedLength], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], NewBoard]) :-
	delete_element_from_list([PlayedPiece, Square, Direction], PlacedPiecesDark, NewList),
	NumScoreCounters is 0, % temporario
	calculate_pos_to_pos(dark_player, Square, WhiteSquare),
	get_number_pieces(Direction, WhiteSquare, NewBoard, NewList, PlacedPiecesLight, NumPieces),
	calculateScoreUponRemoval(PlayedPiece, NumPieces, NumScoreCounters, ScoreToAdd),
	NewScore is ScoreDark + ScoreToAdd,
	piece_info(NewPieceRemovedLength, _, _, _, PlayedPiece),
	format('ScoreToAdd: ~w\n\n', [ScoreToAdd]). % to debug

get_new_state([3, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], PlayedPiece, Square, Direction, NewBoard, [2, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlacementPhasePiecesLight, NewList, NewScore, NewPieceRemovedLength], NewBoard]) :-
	delete_element_from_list([PlayedPiece, Square, Direction], PlacedPiecesLight, NewList),
	NumScoreCounters is 0, % temporario
	get_number_pieces(Direction, Square, NewBoard, PlacedPiecesDark, NewList, NumPieces),
	calculateScoreUponRemoval(PlayedPiece, NumPieces, NumScoreCounters, ScoreToAdd),
	NewScore is ScoreLight + ScoreToAdd,
	piece_info(NewPieceRemovedLength, _, _, _, PlayedPiece),
	format('ScoreToAdd: ~w\n\n', [ScoreToAdd]). % to debug

% move(+State, +Move, -NewState)
% Update the game state based on the move
move([TurnNO, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], LightPlayerInfo, Board], [Piece, Square, Direction], NewState) :-
	turn_phase(TurnNO, placement_phase),
	player_turn(PlayerName, TurnNO),
	place_piece(Board, Square, Direction, PlayerName, Piece, NewBoard),
	get_new_state([TurnNO, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], LightPlayerInfo, _], Piece, Square, Direction, NewBoard, NewState).

move([TurnNO, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], [Piece, Square, Direction], NewState) :-
	turn_phase(TurnNO, scoring_phase),
	player_turn(PlayerName, TurnNO),
	remove_piece(Board, Piece, Square, PlayerName, Direction, NewBoard),
	get_new_state([TurnNO, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], Piece, Square, Direction, NewBoard, NewState).

display_game([TurnNO,_,_,Board]) :-
	clear_console,
	Size is 10,
	SizeMinusOne is Size - 1,
	display_header_coords(Size, Size),
  display_board(Board, SizeMinusOne, Size),
  display_footer_coords(Size, Size), nl, nl, nl,
	display_turn(TurnNO), nl.

% next_phase(+State)
% Verification if the game should move from placing phase to scoring phase
next_phase([TurnNO, [PlacementPhasePiecesDark,_,_,_], [PlacementPhasePiecesLight,_,_,_], Board]) :-
	turn_phase(TurnNO, placement_phase),
	\+canPlaceAPiece(Board, PlacementPhasePiecesDark),
	\+canPlaceAPiece(Board, PlacementPhasePiecesLight).

% retrieve_turn_from_state(+State, -TurnNO)
% gets the turn number from a State
retrieve_turn_from_state([TurnNO|_], TurnNO).

% build_scoring_phase_state(+CurrentState, -NewState)
% build the new state after placement phase ends
build_scoring_phase_state([0, Player1Info, LightPlayerInfo, Board], [3, Player1Info, LightPlayerInfo, Board]).
build_scoring_phase_state([1, Player1Info, LightPlayerInfo, Board], [2, Player1Info, LightPlayerInfo, Board]).
