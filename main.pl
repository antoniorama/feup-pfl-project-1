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
	board(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).

% game_loop(+State)
game_loop(State) :-
	next_phase(State), !, 
	display_game(State),
	write('Placement phase ends'), nl.
%    display_winner(Winner).

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

show_player_pieces([0, [[], _, _, _], _, _]).

show_player_pieces([0, [[Piece | RestPieces], _, _, _], _, _]) :-
    show_player_piece(Piece),  
    show_player_pieces([0, [RestPieces, _, _, _], _, _]).

show_player_pieces([1, _, [[], _, _, _], _]).

show_player_pieces([1, _, [[Piece | RestPieces], _, _, _], _]) :-
    show_player_piece(Piece),
    show_player_pieces([1, _, [RestPieces, _, _, _], _]). 

% choose_move(+State, -Move)
% Gets the move by user input
choose_move(State, Move) :-
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

% Clause for when canPlaceAPiece succeeds for light_player
get_new_state([0, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [1, [NewList, NewPlayedPiecesList, 0, 0], [PlacementPhasePiecesLight, PlacedPiecesLight, 0, 0], NewBoard]) :-
    delete_element_from_list(PlayedPiece, PlacementPhasePiecesDark, NewList),
		append([PlayedPiece, Square, Direction], PlacedPiecesDark, NewPlayedPiecesList),
    canPlaceAPiece(NewBoard, PlacementPhasePiecesLight).

% Clause for when canPlaceAPiece fails for light_player
get_new_state([0, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [0, [NewList, NewPlayedPiecesList, 0, 0], [PlacementPhasePiecesLight, PlacedPiecesLight, 0, 0], NewBoard]) :-
    delete_element_from_list(PlayedPiece, PlacementPhasePiecesDark, NewList),
		append([PlayedPiece, Square, Direction], PlacedPiecesDark, NewPlayedPiecesList),
    \+ canPlaceAPiece(NewBoard, PlacementPhasePiecesLight).

% Clause for when canPlaceAPiece succeeds for dark_player
get_new_state([1, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [0, [PlacementPhasePiecesDark, PlacedPiecesDark, 0, 0], [NewList, NewPlayedPiecesList, 0, 0], NewBoard]) :-
	delete_element_from_list(PlayedPiece, PlacementPhasePiecesLight, NewList),
	append([PlayedPiece, Square, Direction], PlacedPiecesLight, NewPlayedPiecesList),
	canPlaceAPiece(NewBoard, PlacementPhasePiecesDark).

% Clause for when canPlaceAPiece fails for dark_player
get_new_state([1, [PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [1, [PlacementPhasePiecesDark, PlacedPiecesDark, 0, 0], [NewList, NewPlayedPiecesList, 0, 0], NewBoard]) :-
	delete_element_from_list(PlayedPiece, PlacementPhasePiecesLight, NewList),
	append([PlayedPiece, Square, Direction], PlacedPiecesLight, NewPlayedPiecesList),
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
next_phase([_, [PlacementPhasePiecesDark,_,_,_], [PlacementPhasePiecesLight,_,_,_], Board]) :-
	\+canPlaceAPiece(Board, PlacementPhasePiecesDark),
	\+canPlaceAPiece(Board, PlacementPhasePiecesLight).