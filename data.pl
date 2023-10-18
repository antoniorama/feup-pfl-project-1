:- use_module(library(lists)).

% board(+Matrix)
% Matrix representing the board
board(10, [
	[none, none, none, none, none, none, none, none, none, none],
	[none, d1_, d1_, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none]
]).

% square_info(?Player, ?Value, ?ScoreCounter, ?Square)
% Information about a square that is part of a piece
square_info(dark_player, 1, none , d1_).
square_info(dark_player, 2, none, d2_).
square_info(dark_player, 3, none, d3_).
square_info(dark_player, 4, none, d4_).
square_info(dark_player, 6, none, d5_).

square_info(dark_player, 1, sc_dark, d1S).
square_info(dark_player, 2, sc_dark, d2S).
square_info(dark_player, 3, sc_dark, d3S).
square_info(dark_player, 4, sc_dark, d4S).
square_info(dark_player, 6, sc_dark, d6S).

square_info(dark_player, 1, sc_light, d1s).
square_info(dark_player, 2, sc_light, d2s).
square_info(dark_player, 3, sc_light, d3s).
square_info(dark_player, 4, sc_light, d4s).
square_info(dark_player, 6, sc_light, d6s).

square_info(light_player, 1, none, l1_).
square_info(light_player, 2, none, l2_).
square_info(light_player, 3, none, l3_).
square_info(light_player, 4, none, l4_).
square_info(light_player, 6, none, l6_).

square_info(light_player, 1, sc_dark, l1S).
square_info(light_player, 2, sc_dark, l2S).
square_info(light_player, 3, sc_dark, l3S).
square_info(light_player, 4, sc_dark, l4S).
square_info(light_player, 6, sc_dark, l6S).

square_info(light_player, 1, sc_light, l1s).
square_info(light_player, 2, sc_light, l2s).
square_info(light_player, 3, sc_light, l3s).
square_info(light_player, 4, sc_light, l4s).
square_info(light_player, 6, sc_light, l6s).

% square_to_display(+Square, -Display)
square_to_display(d1_, ' P1 ').
square_to_display(d2_, ' P2 ').
square_to_display(d3_, ' P3 ').
square_to_display(d4_, ' P4 ').
square_to_display(d6_, ' P6 ').

square_to_display(d1S, 'S P1').
square_to_display(d2S, 'S P2').
square_to_display(d3S, 'S P3').
square_to_display(d4S, 'S P4').
square_to_display(d6S, 'S P6').

square_to_display(d1s, 's P1').
square_to_display(d2s, 's P2').
square_to_display(d3s, 's P3').
square_to_display(d4s, 's P4').
square_to_display(d6s, 's P6').

square_to_display(l1_, ' B1 ').
square_to_display(l2_, ' B2 ').
square_to_display(l3_, ' B3 ').
square_to_display(l4_, ' B4 ').
square_to_display(l6_, ' B6 ').

square_to_display(l1S, 'S B1').
square_to_display(l2S, 'S B2').
square_to_display(l3S, 'S B3').
square_to_display(l4S, 'S B4').
square_to_display(l6S, 'S B6').

square_to_display(l1s, 's B1').
square_to_display(l2s, 's B2').
square_to_display(l3s, 's B3').
square_to_display(l4s, 's B4').
square_to_display(l6s, 's B6').

% piece_info(?N_Squares, ?Value, ?StartAmmount, ?Player, +PieceName)
% Information of a piece that contains multiple squares
piece_info(3, 1, 5, dark_player, piece1_1).
piece_info(4, 2, 4, dark_player, piece2_1).
piece_info(5, 3, 3, dark_player, piece3_1).
piece_info(6, 4, 2, dark_player, piece4_1).
piece_info(7, 6, 1, dark_player, piece6_1).

piece_info(3, 1, 5, light_player, piece1_2).
piece_info(4, 2, 4, light_player, piece2_2).
piece_info(5, 3, 3, light_player, piece3_2).
piece_info(6, 4, 2, light_player, piece4_2).
piece_info(7, 6, 1, light_player, piece5_2).
