:- consult(data).
:- consult(logic).
:- consult(utils).
:- consult(display).

% start_game initiates the game loop with an initial game state
play :-
    initial_state(State),
    game_loop(State).

% initial_state(-State)
% initialize the state with turn to dark_player (0) and placement phase pieces
initial_state([0, [PlacementPhasePiecesDark, [], 0, 0], [PlacementPhasePiecesLight, [], 0, 0], Board]) :-
	test_board2(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).

% game_loop(+State)
game_loop(State) :-
	retrieve_turn_from_state(State, TurnNO),
	TurnNO >= 0,
	TurnNO =< 1,
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

show_placed_piece_info([Piece, PosWhite, Direction]):-
	piece_info(N_Squares, Value, _, _, Piece),
	format('~w | pos(white for now): ~w direction: ~w length: ~w value: ~w \n\n', [Piece, PosWhite, Direction, N_Squares, Value]).

show_player_pieces(State) :-
  player_pieces(State, List),
	retrieve_turn_from_state(State, TurnNO),
  show_all_player_pieces(List, TurnNO).

% Retrieves the list of pieces for the current player based on the state
player_pieces([0, [Pieces, _, _, _], _, _], Pieces).
player_pieces([1, _, [Pieces, _, _, _], _], Pieces).
player_pieces([2, [_, PlacedPiecesInfo, _, _], _, _], PlacedPiecesInfo).
player_pieces([3, _, [_, PlacedPiecesInfo, _, _], _], PlacedPiecesInfo).

% Helper predicate to show all pieces from the list
show_all_player_pieces([], _). % Base case: no more pieces to show
show_all_player_pieces([Piece | RestPieces], TurnNO) :-
	turn_phase(TurnNO, placement_phase),
  show_player_piece(Piece),
  show_all_player_pieces(RestPieces, TurnNO).

% Info : [Piece, PosWhite, Direction]
show_all_player_pieces([Info | RestPieces], TurnNO) :-
	turn_phase(TurnNO, scoring_phase),
	print_list(Info),
	show_placed_piece_info(Info),
	show_all_player_pieces(RestPieces, TurnNO).

% TODO : This predicate could probably be made more concise (for human player)
% choose_move(+State, -Move)
% Gets the move by user input (for placement phase)
choose_move(State, Move) :-
	retrieve_turn_from_state(State, TurnNO),
	TurnNO >= 0,
	TurnNO =< 1,
	write('Your pieces: \n\n'),
	show_player_pieces(State),
	write('Piece to place: '),
	read(UserInputPiece),
	clear_buffer,
	write('Square to place (ex: 04 or 54): '),
	read_number(UserInputSquare),
	write('Direction to place (horizontal or vertical): '),
	read(UserInputDirection),
	clear_buffer,
	append([UserInputPiece, UserInputSquare, UserInputDirection], [], Move).

% Gets the move by user input (for scoring phase)
choose_move(State, Move) :-
	retrieve_turn_from_state(State, TurnNO),
	TurnNO >= 2,
	TurnNO =< 3,
	write('Placed pieces: \n\n'),
	show_player_pieces(State),
	write('Piece to remove: '),
	read(UserInputPiece),
	clear_buffer,
	write('First square of that piece, from left or top (ex: 04 or 54): '),
	read_number(UserInputSquare),
	write('Direction of that piece (horizontal or vertical): '),
	read(UserInputDirection),
	clear_buffer,
	append([UserInputPiece, UserInputSquare, UserInputDirection], [], Move).

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

% move(+State, +Move, -NewState)
% Update the game state based on the move
move([TurnNO, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], Board], [Piece, Square, Direction], NewState) :-
	player_turn(PlayerName, TurnNO),
	place_piece(Board, Square, Direction, PlayerName, Piece, NewBoard),
	get_new_state([TurnNO, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], Piece, Square, Direction, NewBoard, NewState).

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
	TurnNO >= 0,
	TurnNO =< 1,
	\+canPlaceAPiece(Board, PlacementPhasePiecesDark),
	\+canPlaceAPiece(Board, PlacementPhasePiecesLight).

% retrieve_turn_from_state(+State, -TurnNO)
% gets the turn number from a State
retrieve_turn_from_state([TurnNO|_], TurnNO).

% build_scoring_phase_state(+CurrentState, -NewState)
% build the new state after placement phase ends
build_scoring_phase_state([0, Player1Info, Player2Info, Board], [3, Player1Info, Player2Info, Board]).
build_scoring_phase_state([1, Player1Info, Player2Info, Board], [2, Player1Info, Player2Info, Board]).
