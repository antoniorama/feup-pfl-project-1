game_display([_,_,_,Board]):-
	clear_console,
	Size is 10,
	SizeMinusOne is Size - 1,
	display_header_coords(Size, Size),
    display_board(Board, SizeMinusOne, Size),
    display_footer_coords(Size, Size).

game_cycle(GameState):-
	game_display(GameState).