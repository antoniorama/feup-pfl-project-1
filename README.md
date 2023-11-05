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

#### display_game/2:
The `display_game/2` predicate serves as a key component in visualizing the game state in a textual form for the player. This predicate takes a single argument, which is a list containing the current turn number (TurnNO) and the current state of the game board (Board). The game board is represented as a list of lists, with each sublist representing a row on the board.

The predicate is implemented as a sequence of calls to other predicates, each responsible for displaying different parts of the game interface. Below is an overview of how display_game/2 operates:

Clear Console: The clear_console predicate is called to clear the terminal screen. This ensures that the display starts fresh, providing a clear view of the current game state without any previous content cluttering the screen.

Determine Board Size: The predicate sets Size to 10, which is the size for the game board (10x10). SizeMinusOne is calculated as Size - 1, which is used later to iterate over board coordinates.

Display Header Coordinates: display_header_coords(Size, Size) is called with the board size as arguments. This predicate is responsible for displaying the top coordinates (column headers) of the board, providing a reference for the horizontal axis of the dark player.

Display Board: display_board(Board, SizeMinusOne, Size) is called next. It takes the current board state, the maximum index for iteration (based on SizeMinusOne), and the size of the board. This predicate prints each row of the board along with the row numbers (row headers) for the light and dark players, thus visualizing the cells of the game board in the console.

Display Footer Coordinates: display_footer_coords(Size, Size) is called, mirroring the header coordinates at the bottom of the board for the light player.

Newlines: A series of newline characters are printed (nl, nl, nl) to provide visual separation between the board and the subsequent information.

Display Turn: Finally, display_turn(TurnNO) is called to print the current turn number. This informs the player whose turn it is.

Given the complexity of our game logic, we were suggested to use a fixed board size. Therefore, the input to display_game/2 is assumed to be validated beforehand. It expects the first argument to be a structured list with a turn number and a placeholder (_), and the second argument to be a game board that matches the expected size and structure. The game board is anticipated to be a square matrix of size 10x10, which is a typical requirement for many grid-based games.

User Interface Considerations:
Clarity: The user interface provided by this predicate is designed to be clear and understandable. The board is displayed with coordinates on both the top and bottom, making it easier for players to locate specific positions on the board.
Consistency: The consistent use of Size ensures that if the board size were to change, adjustments could be made in a single place, and the rest of the display logic would adapt accordingly.

In summary, the display_game/2 predicate encapsulates the user interface display logic for the game, rendering the game state in a textual format. It relies on several helper predicates to construct the overall view, with a focus on clarity and simplicity for the user experience.


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

#### initial_state/1:
The initial_state/1 predicate is responsible for setting up the game's initial state. It is critical in establishing the starting point of the game. This predicate is designed to be called without an argument and will unify its single argument with the initial state of the game. Here's an overview of its implementation:

Turn Initialization: The game starts with the dark_player's turn, denoted by 0. This convention is part of the first element of the list that represents the game state.

Placement Phase Initialization: The predicate initializes the game with a placement phase for both dark and light pieces. The structure [PlacementPhasePiecesDark, [], 0, 0] represents the dark player's pieces, where PlacementPhasePiecesDark is a list of dark pieces to be placed on the board, and the two 0s signify the initial score and the length of the last piece removed.

Board Initialization: test_board2(_, Board) is called to retrieve a starting board configuration.

Dark Pieces Setup: initial_dark_pieces(InitialDarkPieces) is invoked to obtain the list of initial dark pieces.

Light Pieces Setup: Similarly, initial_light_pieces(InitialLightPieces) is called to obtain the initial light pieces.

State Assembly: The complete game state is assembled into a single list comprising the current turn, the dark player's pieces, the light player's pieces, and the initial board layout.

The initial_state/1 predicate's role is to create a consistent and reproducible starting point for the game. It ensures that all game components are initialized correctly before the game begins. This setup facilitates an organized start to the game logic, where the state of the game is clearly defined and easy to understand.

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

The `move/3` predicate is a key component of the game's logic that processes and applies a player's move to the game state. It takes the current state and the player's move as input and produces a new game state that reflects the changes after the move.

Predicate Definition:
move(+State, +Move, -NewState)
+State: The current game state before the move.
+Move: The player's move.
-NewState: The game state after the move has been applied.

Implementation Overview:
The move/3 predicate handles two distinct phases of the game: the placement phase and the scoring phase. It uses the turn_phase/2 and player_turn/2 predicates to determine the current phase of the game and which player is making the move.

Placement Phase Logic:

The predicate first checks if the game is in the placement phase using turn_phase(TurnNO, placement_phase).
It then verifies whose turn it is by calling player_turn(PlayerName, TurnNO).
The piece placement is executed by place_piece/6, which takes the board, the specified square and direction, the player, the piece, and returns the updated board as NewBoard.
The predicate get_new_state/6 is then called to construct the new state NewState after the piece has been placed.

Scoring Phase Logic:

If the game is in the scoring phase, determined by turn_phase(TurnNO, scoring_phase), it proceeds with scoring logic.
The player_turn/2 predicate is again used to ascertain who is playing.
A piece is removed from the board using the remove_piece/6 predicate, which similarly requires the current board, the piece in question, the target square, the player's name, and the direction for the move, resulting in NewBoard.
The get_new_state/6 predicate is then invoked to generate the NewState, reflecting the updated board after the piece removal.
Input Validation and Execution:
move/3 inherently validates the move by using the game's rules defined in turn_phase/2, player_turn/2, place_piece/6, and remove_piece/6. If any of these steps fail, the move will not be executed, and the game state will not be updated, effectively enforcing the game's rules.

New State Generation:
The get_new_state/6 predicate is crucial for updating the game state. It must account for changes to the board, the active player's pieces, and possibly the score or other counters if the game is in the scoring phase.

The move/3 predicate encapsulates the logic necessary to transition the game state from one turn to the next, based on the player's move. It handles different game phases and ensures moves are valid and executed according to the game's rules. The predicate relies on several helper predicates to manage the complexity of updating the game state, ensuring that the game logic is modular and maintainable.

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

#### game_over/2:

Predicate Definition:

game_over(+State, -Winner)
+State: The current state of the game, including players' scores and pieces.
-Winner: The outcome of the game, identifying the winner or a draw.
Implementation Overview:
The predicate game_over/2 is implemented with two distinct conditions for the game to be over:

Victory by Score:

The predicate first checks if either player has reached a score of 100 or more, which is a winning condition in this game.
For the dark player, the check is performed with ScoreDark >= 100. If this condition is true, dark_player is unified with the Winner output variable.
Similarly, for the light player, ScoreLight >= 100 must be true to unify light_player with the Winner.

Inability to Play:

If neither player has reached the winning score, the game checks if both players are unable to make a legal move.
This is determined by the helper predicates cannot_play/2, which takes a player and the current state as arguments.
If both cannot_play(dark_player, State) and cannot_play(light_player, State) succeed, it indicates that neither player can perform a valid move, signaling the end of the game.
The get_winner/2 predicate is then called to determine the winner based on the current state. This could involve comparing scores or applying other tie-breaking rules.
Handling Game Conclusion:
The game_over/2 predicate does not directly modify the game state but rather inspects it to determine if end conditions are met. The definition implies the following logic for game termination:

Victory Condition: A player is declared the winner if their score reaches or exceeds the predetermined threshold (e.g., 100 points).
Draw Condition: The game ends in a draw if both players are unable to make a valid move. The actual winner in this scenario, or the logic to handle a draw, would depend on the implementation of get_winner/2.
Summary:
The game_over/2 predicate is critical for monitoring the end conditions of the game. By evaluating the players' scores and their ability to continue playing, it maintains the integrity of the game's conclusion. The modularity of this predicate, with reliance on cannot_play/2 and get_winner/2, also promotes a clean separation of concerns within the game's logic.

```prolog
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
```

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
