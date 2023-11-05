:- use_module(library(lists)).
:- use_module(library(random)).

% board(+Matrix)
% Matrix representing the board

% the boards are represented according to white coordinates
board(10, [
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none],
	[none, none, none, none, none, none, none, none, none, none]
]).

test_board(10, [
	[d6_, d6_, d6_, d6_, d6_, d6_, d6_, d6_, d6_, d6_],
	[d6_, none, d6_, none, none, none, none, none, d6_, d6_],
	[d6_, none, d6_, d6_, d6_, none, d6_, d6_, d6_, d6_],
	[d6_, d6_, d6_, d6_, d6_, none, d6_, d6_, none, d6_],
	[d6_, none, d6_, d6_, none, d6_, d6_, none, d6_, d6_],
	[d6_, d6_, none, d6_, d6_, d6_, none, d6_, none, d6_],
	[none, none, none, none, none, none, none, none, none, d6_],
	[d6_, d6_, d6_, d6_, none, d6_, d6_, none, d6_, d6_],
	[d6_, d6_, d6_, none, d6_, none, none, d6_, none, d6_],
	[d6_, d6_, d6_, d6_, d6_, d6_, d6_, d6_, d6_, d6_]
]).

test_board2(10, [
	[d3_, d3_, d3_, d3_, d3_, d2_, d2_, d2_, d2_, none],
	[l1_, d2s, l6_, l6_, l6_, l6_, l6_, l6_, l6_, l1_],
	[l1_, none, d1_, l4_, l4_, l4_, l4_, l4_, l4_, l1_],
	[l1_, none, d1_, l4_, l4_, l4_, l4_, l4_, l4_, l1_],
	[l1_, none, d1_, l1_, l1_, l1_, d2_, d2_, d2_, d2_],
	[l1_, none, none, none, l3_, l3_, l2_, l2_, l2_, l2_],
	[l1_, d1_, d1_, d1_, l3_, l3_, d2_, d2_, d2_, d2_],
	[d1_, d1_, d1_, none, l3_, l3_, l2_, l2_, l2_, l2_],
	[l2_, l2_, l2_, l2_, l3_, l3_, d1_, d1_, d1_, none],
	[d2_, d2_, d2_, d2_, l3_, l3_, l2_, l2_, l2_, l2_]
]).

test_board3(10, [
	[d3_, d3_, d3_, d3_, d3_, d2s, d2_, d2_, d2_, none],
	[l1_, none, l6_, l6_, l6_, l6_, l6_, l6_, l6_, l1_],
	[l1_, none, d1_, l4_, l4_, l4_, l4_, l4_, l4_, l1_],
	[l1_, none, d1_, l4_, l4_, l4_, l4_, l4_, l4_, l1_],
	[l1_, none, d1_, l1_, l1_, l1_, d2_, d2_, d2_, d2_],
	[l1_, none, none, none, l3_, l3_, l2_, l2_, l2_, l2_],
	[l1_, d1_, d1_, d1_, l3_, l3_, d2_, d2_, d2_, d2_],
	[d1_, d1_, d1_, none, l3_, l3_, l2_, l2_, l2_, l2_],
	[l2_, l2_, l2_, l2_, l3_, l3_, d1_, d1_, d1_, none],
	[d2_, d2_, d2_, d2_, l3_, l3_, l2_, l2_, l2_, l2S]
]).

% square_info(?Player, ?Value, ?ScoreCounter, ?Square)
% Information about a square that is part of a piece
square_info(dark_player, 1, none, d1_).
square_info(dark_player, 2, none, d2_).
square_info(dark_player, 3, none, d3_).
square_info(dark_player, 4, none, d4_).
square_info(dark_player, 6, none, d6_).

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

square_info(light_player, _, sc_light, slight).
square_info(dark_player, _, sc_dark, sdark).

square_info(_, _, _, none).

%withOrWithoutCounter(?PieceWithCounter, ?PieceWithoutCounter).
%useful to remove score counter from a piece
withOrWithoutCounter(d1s, d1_).
withOrWithoutCounter(d1S, d1_).
withOrWithoutCounter(d2s, d2_).
withOrWithoutCounter(d2S, d2_).
withOrWithoutCounter(d3s, d3_).
withOrWithoutCounter(d3S, d3_).
withOrWithoutCounter(d4s, d4_).
withOrWithoutCounter(d4S, d4_).
withOrWithoutCounter(d6s, d6_).
withOrWithoutCounter(d6S, d6_).

withOrWithoutCounter(l1s, l1_).
withOrWithoutCounter(l1S, l1_).
withOrWithoutCounter(l2s, l2_).
withOrWithoutCounter(l2S, l2_).
withOrWithoutCounter(l3s, l3_).
withOrWithoutCounter(l3S, l3_).
withOrWithoutCounter(l4s, l4_).
withOrWithoutCounter(l4S, l4_).
withOrWithoutCounter(l6s, l6_).
withOrWithoutCounter(l6S, l6_).

withOrWithoutCounter(S, none).
withOrWithoutCounter(s, none).


%useful to add score counter on top of a piece
withOrWithoutCounterLight(d1s, d1_).
withOrWithoutCounterDark(d1S, d1_).
withOrWithoutCounterLight(d2s, d2_).
withOrWithoutCounterDark(d2S, d2_).
withOrWithoutCounterLight(d3s, d3_).
withOrWithoutCounterDark(d3S, d3_).
withOrWithoutCounterLight(d4s, d4_).
withOrWithoutCounterDark(d4S, d4_).
withOrWithoutCounterLight(d6s, d6_).
withOrWithoutCounterDark(d6S, d6_).

withOrWithoutCounterLight(l1s, l1_).
withOrWithoutCounterDark(l1S, l1_).
withOrWithoutCounterLight(l2s, l2_).
withOrWithoutCounterDark(l2S, l2_).
withOrWithoutCounterLight(l3s, l3_).
withOrWithoutCounterDark(l3S, l3_).
withOrWithoutCounterLight(l4s, l4_).
withOrWithoutCounterDark(l4S, l4_).
withOrWithoutCounterLight(l6s, l6_).
withOrWithoutCounterDark(l6S, l6_).

withOrWithoutCounterDark(S, none).
withOrWithoutCounterLight(s, none).

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

square_to_display(slight, ' s  ').
square_to_display(sdark, ' S  ').

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
piece_info(7, 6, 1, light_player, piece6_2).

initial_dark_pieces([piece1_1, piece1_1, piece1_1, piece1_1, piece1_1, piece2_1, piece2_1, piece2_1, piece2_1, piece3_1, piece3_1, piece3_1, piece4_1, piece4_1, piece6_1]).
initial_light_pieces([piece1_2, piece1_2, piece1_2, piece1_2, piece1_2, piece2_2, piece2_2, piece2_2, piece2_2, piece3_2, piece3_2, piece3_2, piece4_2, piece4_2, piece6_2]).

% piece_default_square(?PieceName, ?DefaultSquare)
piece_default_square(piece1_1, d1_).
piece_default_square(piece2_1, d2_).
piece_default_square(piece3_1, d3_).
piece_default_square(piece4_1, d4_).
piece_default_square(piece6_1, d6_).

piece_default_square(piece1_2, l1_).
piece_default_square(piece2_2, l2_).
piece_default_square(piece3_2, l3_).
piece_default_square(piece4_2, l4_).
piece_default_square(piece6_2, l6_).

% player_turn(?Name, ?TurnNO)
player_turn(dark_player, 0).
player_turn(light_player, 1).
player_turn(dark_player, 2).

% turn_phase(?TurnNO, ?Phase)
turn_phase(0, placement_phase).
turn_phase(1, placement_phase).
turn_phase(2, scoring_phase).
turn_phase(3, scoring_phase).
turn_phase(4, placement_phase).
turn_phase(5, placement_phase).

% swap_turn(?CurrentTurn, ?NextTurn)
swap_turn(0, 1).
swap_turn(1, 0).
swap_turn(2, 3).
swap_turn(3, 2).
swap_turn(4, 5).
swap_turn(5, 4).

% difficulty(?PlayerName, ?Level)
difficulty(dark_bot1, 1).
difficulty(light_bot1, 1).

% bot(?PlayerName)
bot(dark_bot1).
bot(light_bot1).

bot_to_regular_player(dark_bot1, dark_player).
bot_to_regular_player(light_bot1, light_player).

bot_to_player_turn(0, 4).
bot_to_player_turn(1, 5).
bot_to_player_turn(2, 6).
bot_to_player_turn(3, 7).