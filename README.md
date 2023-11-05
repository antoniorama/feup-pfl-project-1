# ISAAC

## Group Information

- **Group Name**: Isaac_7
- **Members**:
  - Full Name: António Marujo Rama, Student Number: up2021*****,  Contribution: 50%
  - Full Name: Miguel Pedrosa, Student Number: up202108809, Contribution: 50%
## Installation and Execution

### Linux

1. Ensure that SICStus Prolog 4.8 is installed on your system.

2. Download the game files.
3. Navigate to the game directory.
   - `cd path/to/game`
4. Start SICStus Prolog with the game file.
   - `sicstus -l main.pl`
5. Run the game.
   - `play`

### Windows

1. Ensure that SICStus Prolog 4.8 is installed on your system.

2. Download the game files.
3. Navigate to the game directory in Command Prompt.
4. Start SICStus Prolog with the game file.
   - `consult('path/to/main.pl').`
5. Run the game.
   - `play`

## Description of the Game

In this two-player board game, the objective is to accumulate points through strategic tile placement and removal during two main phases: the Placement Phase and the Scoring Phase.

Placement Phase:
The game begins with an empty board. Players take turns placing one of their tiles on unoccupied cells, starting with the player using dark tiles. If a player cannot place a tile, they pass, allowing the other player to continue. The phase concludes when the board cannot accommodate any more tiles, and any remaining tiles are kept aside for potential tie-breaking.

Scoring Phase:
Both players start with zero points. The first player to pass in the Placement Phase begins the Scoring Phase, removing one tile at a time from the board. Each removed tile must be equal to or longer than the last one removed by that player. Tiles under score counters cannot be removed. Points are scored by multiplying the number on the removed tile by the count of tiles along the removal line, with multipliers applied if score counters are on this line. The score counter is then moved along a path, aiming to reach a score of 100 points.
If any player cannot remove any of his tiles on his turn, he passes and is out of the game. The game ends when both players have passed.

[igGameCenter official website] (https://www.iggamecenter.com) 
<br>
[Isaac rule book] (https://www.iggamecenter.com/en/rules/isaac) 

## Game Logic

### Internal Game State Representation

[Describe how the game state is represented in Prolog, including examples of initial, intermediate, and final states.]


### Game State Visualization

[Describe how the game state display predicate `display_game/2` is implemented, including the user interface and input validation.]
```prolog

display_game([TurnNO,_,_,Board]) :-
	clear_console,
	Size is 10,
	SizeMinusOne is Size - 1,
	display_header_coords(Size, Size),
  	display_board(Board, SizeMinusOne, Size),
  	display_footer_coords(Size, Size), nl, nl, nl,
	display_turn(TurnNO), nl.
```

```prolog
% initial_state(-State)
% initialize the state with turn to dark_player (0) and placement phase pieces
initial_state([0, [PlacementPhasePiecesDark, [], 0, 0], [PlacementPhasePiecesLight, [], 0, 0], Board]) :-
	test_board2(_, Board),
	initial_dark_pieces(InitialDarkPieces),
	append(InitialDarkPieces, [], PlacementPhasePiecesDark),
	initial_light_pieces(InitialLightPieces),
	append(InitialLightPieces, [], PlacementPhasePiecesLight).
```

### Move Validation and Execution

[Describe the predicate `move/3` for validating and executing a play.]
```prolog
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
```


### List of Valid Moves

[Detail how the list of possible moves is generated with the predicate `valid_moves/3`.]

### End of Game

[Explain the predicate `game_over/2` for checking the end of the game and determining the winner.]

### Game State Evaluation

[Discuss how the game state is evaluated through the `value/3` predicate.]

### Computer Plays

[Describe how the computer selects a move using the `choose_move/4` predicate based on different levels of difficulty.]
#### Level 2 Bot

The core of the Level 2 bot's decision-making process in our game is encapsulated in the `choose_move/4` predicate. This predicate, unlike the random selection method employed by the Level 1 bot, implements a strategic approach through the Minimax algorithm. The Minimax algorithm is a backtracking algorithm that is used in decision-making and game theory to find the optimal move for a player, assuming that the opponent is also playing optimally.

In the context of our Prolog-based game, the `choose_move/4` predicate operates as follows when applied to the Level 2 bot:

1. **Initial Function Call:**
   The predicate is first called with the current state of the game, the bot's identifier, the depth of analysis, and an indicator of the bot's level of difficulty.

2. **Tree Generation:**
   Starting from the current game state, the predicate generates a game tree representing all possible future moves, up to a certain depth. Each node of the tree corresponds to a game state, which results from a possible move by either the bot or its opponent.

3. **Minimax Algorithm:**
   Once the tree is constructed, the Minimax algorithm is applied recursively. The algorithm traverses the tree, applying the following logic:
   
   - **Minimizer and Maximizer:** There are two kinds of nodes—minimizer (opponent) and maximizer (bot). The maximizer aims to maximize the score, while the minimizer tries to get the lowest score possible.
   - **Base Case:** The recursion hits a base case when it reaches a terminal node (a win, loss, or draw) or when the specified depth limit is reached. In these cases, a heuristic value is returned, which is a measure of the desirability of that node (game state).
   - **Recursive Case:** For non-terminal nodes, the algorithm recursively calls itself for all the children, alternating between minimizing and maximizing according to whose move it is.

4. **Move Evaluation:**
   Each move's potential is evaluated using a heuristic function that scores the game states. This heuristic takes into account various factors such as material count, positional advantages, and potential future moves. For the Level 2 bot, this evaluation must be sophisticated enough to provide a good approximation of the game state's utility.

5. **Decision Making:**
   After all possible moves have been evaluated, the algorithm chooses the move that leads to the outcome with the maximum score for the bot, while considering that the opponent is making the best possible counter moves. This is done by propagating the minimax values up the tree.

6. **Final Move Selection:**
   The `choose_move/4` predicate finally returns the move with the highest minimax value as the bot's selected action.

Through the implementation of the Minimax algorithm within the `choose_move/4` predicate, the Level 2 bot is able to play "intelligently" by considering not only immediate gains but also future implications of its moves. This predictive capability, paired with the recursive nature of the Minimax algorithm, allows the bot to select moves that increase its chances of winning against an opponent playing at its best potential.

## Conclusions

The development of this game was a multifaceted challenge that required the team to delve into complex logic structures and interactive design using Prolog, which is not commonly employed for game development. Successfully implementing the game's rules in a logical and user-friendly manner represents a significant accomplishment for our group.

Throughout the project, we encountered several constraints. Prolog's unique paradigm presented a steep learning curve, particularly in terms of state representation and visualization. Moreover, due to the language's limitations in graphical interfaces, the game lacks a modern, engaging UI which could potentially enhance user experience.

Implementing a more sophisticated AI by incorporating learning algorithms could provide a richer and more challenging gameplay experience.

In conclusion, this project not only provided a hands-on experience with Prolog but also contributed to the understanding of its capabilities and limitations within the scope of game development.

## Bibliography

- IG Game Center. (n.d.). _Main Page_. Retrieved November 1, 2023, from https://www.iggamecenter.com/
- IG Game Center. (n.d.). _Isaac Game Rules_. Retrieved November 1, 2023, from https://www.iggamecenter.com/en/rules/isaac


## Game Execution Images

![Initial Game State](path/to/initial_state_image.png)
*Initial game state.*

![Intermediate Game State](path/to/intermediate_state_image.png)
*Intermediate game state.*

![Final Game State](path/to/final_state_image.png)
*Final game state.*
