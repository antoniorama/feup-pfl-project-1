:- consult(data).
:- consult(logic).
:- consult(utils).
:- consult(display).

% start_game initiates the game loop with an initial game state
play :-
		% game_mode(Mode),
    % initial_state(Mode, State),
		test_placement_phase_state(State), % just to test
    game_loop(State).

% game_mode(-Mode)
game_mode(Mode) :-
	write('1) Player vs Player\n'),
	write('2) Bot Lvl 1 vs Bot Lvl 1\n'),
	write('3) Player vs Bot Lvl 1\n'),
	write('Choose game mode: '),
	read_number(Mode).

% initial_state(+Mode, -State)
% initialize the state with turn to dark_player (0) and placement phase pieces
initial_state(1, [0, [dark_player, PlacementPhasePiecesDark, [], 0, 0], [light_player, PlacementPhasePiecesLight, [], 0, 0], Board]) :-
	board(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).

% bot lvl 1 vs bot lvl 1
initial_state(2, [0, [dark_bot1, PlacementPhasePiecesDark, [], 0, 0], [light_bot1, PlacementPhasePiecesLight, [], 0, 0], Board]) :-
	board(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).

% player vs bot lvl 1
initial_state(3, [0, [dark_bot1, PlacementPhasePiecesDark, [], 0, 0], [light_player, PlacementPhasePiecesLight, [], 0, 0], Board]) :-
	board(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).

initial_state(_, _) :-
	write('\nChoose a valid game mode. \n'),
	play.

% just a state to test placement phase
test_placement_phase_state([3, [dark_player, _, [[piece2_1, 09, horizontal],[piece1_1, 29, horizontal],[piece1_1, 13, horizontal],[piece1_1, 38, horizontal],[piece2_1, 33, horizontal],[piece1_1, 57, vertical],[piece2_1, 53, horizontal],[piece3_1, 99, horizontal],[piece2_1, 94, horizontal]], 0, 7], [light_player,_,[[piece6_2, 12, horizontal],[piece4_2, 23, horizontal],[piece1_2, 30, vertical],[piece4_2, 33, horizontal],[piece1_2, 39, vertical],[piece1_2, 43, horizontal],[piece2_2, 56, horizontal],[piece1_2, 60, vertical],[piece2_2, 76, horizontal],[piece2_2, 80, horizontal],[piece3_2, 94, vertical],[piece3_2, 95, vertical],[piece2_2, 96, horizontal]],5,7],Board]) :- 
	board(_, Board).

% game_loop(+State)
% check switching phases
game_loop(State) :-
	retrieve_turn_from_state(State, TurnNO),
	turn_phase(TurnNO, placement_phase),
	next_phase(State), !, 
	write('Placement phase ends'), nl,
	display_game(State),
	build_scoring_phase_state(State, NewState),
	game_loop(NewState).

% check ending game
game_loop(State) :-
	retrieve_turn_from_state(State, TurnNO),
	turn_phase(TurnNO, scoring_phase),
	game_over(State, Winner), !,
	format('GAME OVER, winner is ~w\n', [Winner]).

% main game loop
game_loop(State) :-
    % Display the current state of the game
		print_list(State),
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
	format('~w ) ~w | pos : ~w direction: ~w length: ~w\n\n', [Index, Piece, PosWhite, Direction, N_Squares]).

show_player_pieces(State) :-
  player_pieces(State, List),
	retrieve_turn_from_state(State, TurnNO),
  show_all_player_pieces(List, TurnNO, 1).

% Retrieves the list of pieces for the current player based on the state
player_pieces([0, [_, Pieces, _, _, _], _, _], Pieces).
player_pieces([1, _, [_, Pieces, _, _, _], _], Pieces).
player_pieces([2, [_, _, PlacedPiecesInfo, _, _], _, _], PlacedPiecesInfo).
player_pieces([3, _, [_, _, PlacedPiecesInfo, _, _], _], PlacedPiecesInfo).

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
show_scores([_, [_,_,_,ScoreDark, PieceRemovedLenghtDark], [_,_,_,ScoreLight, PieceRemovedLenghtLight], _]) :-
	format('Dark Player - Score : ~w PieceRemovedLength : ~w\n', [ScoreDark, PieceRemovedLenghtDark]),
	format('Light Player - Score : ~w PieceRemovedLength : ~w\n\n', [ScoreLight, PieceRemovedLenghtLight]).

% TODO : This predicate could probably be made more concise (for human player)
% choose_move(+State, -Move)
% Gets the move by user input (for placement phase)
choose_move([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], [UserInputPiece, UserInputSquare, UserInputDirection]) :-
	turn_phase(TurnNO, placement_phase),
	get_player_from_state([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], PlayerName),
	\+ bot(PlayerName),
	write('Your pieces: \n\n'),
	show_player_pieces([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board]),
	write('Piece to place: '),
	read(UserInputPiece),
	clear_buffer,
	write('Square to place (ex: 04 or 54): '),
	read_number(UserInputSquare),
	write('Direction to place (horizontal or vertical): '),
	read(UserInputDirection),
	clear_buffer.

% Gets the move by user input (for scoring phase)
choose_move([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], Move) :-
	turn_phase(TurnNO, scoring_phase),
	get_player_from_state([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], PlayerName),
	\+ bot(PlayerName),
	show_scores([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board]),
	write('Placed pieces: \n\n'),
	show_player_pieces([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board]),
	write('Piece to remove: '),
	read_number(UserInput),
	get_move_from_placed_list([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], UserInput, Move),
	validate_move([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], Move).

choose_move(State, Move) :-
  get_player_from_state(State, PlayerName),
	bot(PlayerName),
	difficulty(PlayerName, Level),
	choose_move(State, PlayerName, Level, Move).

% CHOOSE BOT MOVE

% choose_move(+State, +Player, +Level, -Move)
% for level 1 bot (valid random move)
choose_move([TurnNO, DarkPlayerInfo, LightPlayerInfo, Board], _, 1, [RandomPiece, RandomSquare, RandomDirection]) :-
	random(0, 100, RandomSquare),
	get_placement_pieces_from_state([TurnNO, DarkPlayerInfo, LightPlayerInfo, Board], PieceList),
	get_random_piece(PieceList, RandomPiece),
	get_random_direction(RandomDirection).

% get_random_piece(+PieceList,- RandomPiece)
% gets a random piece from a piece list
get_random_piece(PieceList, RandomPiece) :-
	length(PieceList, Length),
	random(0, Length, RandomIndex),
	nth0(RandomIndex, PieceList, RandomPiece).

% get_random_direction(-Direction)
% gets a random direction (horizontal or vertical)
get_random_direction(Direction) :-
	random(0, 2, RandomIndex),
	nth0(RandomIndex, [horizontal, vertical], Direction).

% get_move_from_placed_list(+State, +Index, -Move)
get_move_from_placed_list([2, [_, _, PlacedPiecesDark, _, _], _, _], Index, Move) :-
	nth1(Index, PlacedPiecesDark, Move).

get_move_from_placed_list([3, _, [_, _, PlacedPiecesLight, _, _], _], Index, Move) :-
	nth1(Index, PlacedPiecesLight, Move).

% validate_moves(+State, +Move)
% validates a move
validate_move([2 ,[_, _, PlacedPiecesDark, _, _], _, Board], Move) :-
	member(Move, PlacedPiecesDark).

validate_move([3 , _, [_, _, PlacedPiecesLight, _, _], Board], Move) :-
	member(Move, PlacedPiecesLight).

% TODO - THIS SHOULD BE MORE CONCISE (IF CANNOT PLAY, THEN STAY IN THE SAME TURN SHOULDN'T NEED TWO WHOLE RULES)
% Clause for when canPlaceAPiece succeeds for light_player
% Clause for when canPlaceAPiece succeeds for light_player
get_new_state([0, [PlayerDarkName,PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [1, [PlayerDarkName, NewList, NewPlayedPiecesList, 0, 0], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, 0, 0], NewBoard]) :-
    delete_element_from_list(PlayedPiece, PlacementPhasePiecesDark, NewList),
		append([[PlayedPiece, Square, Direction]], PlacedPiecesDark, NewPlayedPiecesList),
    canPlaceAPiece(NewBoard, PlacementPhasePiecesLight).

% Clause for when canPlaceAPiece fails for light_player
get_new_state([0, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [0, [PlayerDarkName, NewList, NewPlayedPiecesList, 0, 0], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, 0, 0], NewBoard]) :-
    delete_element_from_list(PlayedPiece, PlacementPhasePiecesDark, NewList),
		append([[PlayedPiece, Square, Direction]], PlacedPiecesDark, NewPlayedPiecesList),
    \+ canPlaceAPiece(NewBoard, PlacementPhasePiecesLight).

% Clause for when canPlaceAPiece succeeds for dark_player
get_new_state([1, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [0, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, 0, 0], [PlayerLightName, NewList, NewPlayedPiecesList, 0, 0], NewBoard]) :-
	delete_element_from_list(PlayedPiece, PlacementPhasePiecesLight, NewList),
	append([[PlayedPiece, Square, Direction]], PlacedPiecesLight, NewPlayedPiecesList),
	canPlaceAPiece(NewBoard, PlacementPhasePiecesDark).

% Clause for when canPlaceAPiece fails for dark_player
get_new_state([1, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, _, _], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, _, _], _], PlayedPiece, Square, Direction, NewBoard, [1, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, 0, 0], [PlayerLightName, NewList, NewPlayedPiecesList, 0, 0], NewBoard]) :-
	delete_element_from_list(PlayedPiece, PlacementPhasePiecesLight, NewList),
	append([[PlayedPiece, Square, Direction]], PlacedPiecesLight, NewPlayedPiecesList),
	\+ canPlaceAPiece(NewBoard, PlacementPhasePiecesDark).

get_new_state([2, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], PlayedPiece, Square, Direction, NewBoard, [3, [PlayerDarkName, PlacementPhasePiecesDark, NewList, NewScore, NewPieceRemovedLength], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], UpdatedBoard]) :-
	delete_element_from_list([PlayedPiece, Square, Direction], PlacedPiecesDark, NewList),
	NumScoreCounters is 0, % temporario
	calculate_pos_to_pos(dark_player, Square, WhiteSquare),
	get_number_pieces(Direction, WhiteSquare, NewBoard, NewList, PlacedPiecesLight, NumPieces),
	calculateScoreUponRemoval(PlayedPiece, NumPieces, NumScoreCounters, ScoreToAdd),
	NewScore is ScoreDark + ScoreToAdd,
	updateScoreCounter(ScoreLight, NewScore, NewBoard, UpdatedBoard),
	piece_info(NewPieceRemovedLength, _, _, _, PlayedPiece),
	\+ cannot_play(light_player, [3, [PlacementPhasePiecesDark, NewList, NewScore, NewPieceRemovedLength], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], NewBoard]).

get_new_state([2, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], Board], PlayedPiece, Square, Direction, NewBoard, [2, [PlayerDarkName, PlacementPhasePiecesDark, NewList, NewScore, NewPieceRemovedLength], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], UpdatedBoard]) :-
	delete_element_from_list([PlayedPiece, Square, Direction], PlacedPiecesDark, NewList),
	NumScoreCounters is 0, % temporario
	calculate_pos_to_pos(dark_player, Square, WhiteSquare),
	get_number_pieces(Direction, WhiteSquare, NewBoard, NewList, PlacedPiecesLight, NumPieces),
	calculateScoreUponRemoval(PlayedPiece, NumPieces, NumScoreCounters, ScoreToAdd),
	NewScore is ScoreDark + ScoreToAdd,
	updateScoreCounter(ScoreLight, NewScore, NewBoard, UpdatedBoard),
	piece_info(NewPieceRemovedLength, _, _, _, PlayedPiece),
	cannot_play(light_player, [3, [PlacementPhasePiecesDark, NewList, NewScore, NewPieceRemovedLength], [PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLenghtLight], NewBoard]).

get_new_state([3, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], PlayedPiece, Square, Direction, NewBoard, [2, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, NewList, NewScore, NewPieceRemovedLength], UpdatedBoard]) :-
	delete_element_from_list([PlayedPiece, Square, Direction], PlacedPiecesLight, NewList),
	NumScoreCounters is 0, % temporario
	get_number_pieces(Direction, Square, NewBoard, PlacedPiecesDark, NewList, NumPieces),
	calculateScoreUponRemoval(PlayedPiece, NumPieces, NumScoreCounters, ScoreToAdd),
	NewScore is ScoreLight + ScoreToAdd,
	updateScoreCounter(NewScore, ScoreDark, NewBoard, UpdatedBoard),
	piece_info(NewPieceRemovedLength, _, _, _, PlayedPiece),
	\+ cannot_play(dark_player, [2, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, NewList, NewScore, NewPieceRemovedLength], NewBoard]).

get_new_state([3, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], PlayedPiece, Square, Direction, NewBoard, [3, [PlayerDarkName, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerLightName, PlacementPhasePiecesLight, NewList, NewScore, NewPieceRemovedLength], UpdatedBoard]) :-
	delete_element_from_list([PlayedPiece, Square, Direction], PlacedPiecesLight, NewList),
	NumScoreCounters is 0, % temporario
	get_number_pieces(Direction, Square, NewBoard, PlacedPiecesDark, NewList, NumPieces),
	calculateScoreUponRemoval(PlayedPiece, NumPieces, NumScoreCounters, ScoreToAdd),
	NewScore is ScoreLight + ScoreToAdd,
	updateScoreCounter(NewScore, ScoreDark, NewBoard, UpdatedBoard),
	piece_info(NewPieceRemovedLength, _, _, _, PlayedPiece),
	cannot_play(dark_player, [2, [PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlacementPhasePiecesLight, NewList, NewScore, NewPieceRemovedLength], NewBoard]).

% move(+State, +Move, -NewState)
% Update the game state based on the move
move([TurnNO, DarkPlayerInfo, LightPlayerInfo, Board], [Piece, Square, Direction], NewState) :-
	turn_phase(TurnNO, placement_phase),
	player_turn(PlayerName, TurnNO),
	format('~w ~w ~w ~w\n', [Piece, Square, Direction, PlayerName]),
	print_list(Board),
	place_piece(Board, Square, Direction, PlayerName, Piece, NewBoard),
	get_new_state([TurnNO, DarkPlayerInfo, LightPlayerInfo, _], Piece, Square, Direction, NewBoard, NewState).

move([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], [Piece, Square, Direction], NewState) :-
	\+ pieceHasScoreCounter(Board, Piece, Square, Direciton),
	turn_phase(TurnNO, scoring_phase),
	player_turn(PlayerName, TurnNO),
	remove_piece(Board, Piece, Square, PlayerName, Direction, NewBoard),
	get_new_state([TurnNO, [PlayerNameDark, PlacementPhasePiecesDark, PlacedPiecesDark, ScoreDark, PieceRemovedLenghtDark], [PlayerNameLight, PlacementPhasePiecesLight, PlacedPiecesLight, ScoreLight, PieceRemovedLengthLight], Board], Piece, Square, Direction, NewBoard, NewState).

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
next_phase([TurnNO, [_,PlacementPhasePiecesDark,_,_,_], [_,PlacementPhasePiecesLight,_,_,_], Board]) :-
	turn_phase(TurnNO, placement_phase),
	\+canPlaceAPiece(Board, PlacementPhasePiecesDark),
	\+canPlaceAPiece(Board, PlacementPhasePiecesLight).

% game_over(+State, -Winner)
% over by score
game_over([_, [_,_, _, ScoreDark, _], _, _], dark_player) :-
	ScoreDark >= 100.

game_over([_, _, [_,_, _, ScoreLight, _], _], light_player) :-
	ScoreLight >= 100.

% over if both players can't play
game_over(State, Winner) :- 
	cannot_play(dark_player, State),
	cannot_play(light_player, State),
	get_winner(State, Winner).

% cannot_play(+Player, +State)
% a player cannot play if their largest piece is less than PieceRemovedLength -OR- they have 0 pieces
cannot_play(dark_player, [_, [_,_, [], _, _], _, _]).
cannot_play(light_player, [_, _, [_,_, [], _, _], _]).

cannot_play(dark_player, [_, [_,_, PlacedPiecesDark, _, PieceRemovedLenghtDark], _, _]) :-
	collect_first_elements(PlacedPiecesDark, PieceList),
	piece_n_squares(PieceList, LengthList),
	max_member(MaxLength, LengthList),
	MaxLength < PieceRemovedLenghtDark.

cannot_play(light_player, [_, _, [_,_, PlacedPiecesLight, _, PieceRemovedLenghtLight], _]) :-
	collect_first_elements(PlacedPiecesLight, PieceList),
	piece_n_squares(PieceList, LengthList),
	max_member(MaxLength, LengthList),
	MaxLength < PieceRemovedLenghtLight.

% get_winner(+State, -Winner)
% gets winner in case of both players not being able to play
get_winner([_, [_,_, _, ScoreDark, _], [_,_, _, ScoreLight, _], _], dark_player) :-
	ScoreDark > ScoreLight.

get_winner([_, [_,_, _, ScoreDark, _], [_,_, _, ScoreLight, _], _], light_player) :-
	ScoreLight > ScoreDark.

% in case of draw
% get_winner([_, [_, _, ScoreDark, _], [_, _, ScoreLight, _], _], light_player) :-
%	ScoreLight =:= ScoreDark.

% retrieve_turn_from_state(+State, -TurnNO)
% gets the turn number from a State
retrieve_turn_from_state([TurnNO|_], TurnNO).

% build_scoring_phase_state(+CurrentState, -NewState)
% build the new state after placement phase ends
build_scoring_phase_state([0, Player1Info, LightPlayerInfo, Board], [3, Player1Info, LightPlayerInfo, FinalBoard]) :-
	placeScoreCounterLightInitial(Board, NewBoard),
	placeScoreCounterDarkInitial(NewBoard, FinalBoard).

build_scoring_phase_state([1, Player1Info, LightPlayerInfo, Board], [2, Player1Info, LightPlayerInfo, FinalBoard]) :-
	placeScoreCounterLightInitial(Board, NewBoard),
	placeScoreCounterDarkInitial(NewBoard, FinalBoard).

% get_player_from_state(+State, -PlayerName)
get_player_from_state([0, [PlayerNameDark, _, _, _, _], _, _], PlayerNameDark).
get_player_from_state([1, _, [PlayerNameLight, _, _, _, _], _], PlayerNameLight).
get_player_from_state([2, [PlayerNameDark, _, _, _, _], _, _], PlayerNameDark).
get_player_from_state([3, _, [PlayerNameLight, _, _, _, _], _], PlayerNameLight).

% get_placement_pieces_from_state(+State, -PlacementPieces)
get_placement_pieces_from_state([0, [_, PlacementPhasePiecesDark, _, _, _], _, _], PlacementPhasePiecesDark).
get_placement_pieces_from_state([1, _, [_, PlacementPhasePiecesLight, _, _, _], _], PlacementPhasePiecesLight).
get_placement_pieces_from_state([2, [_, PlacementPhasePiecesDark, _, _, _], _, _], PlacementPhasePiecesDark).
get_placement_pieces_from_state([3, _, [_, PlacementPhasePiecesLight, _, _, _], _], PlacementPhasePiecesLight).