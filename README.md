# ISAAC

## Group Information

- **Group Name**: Isaac_7
- **Members**:
  - Full Name: António Marujo Rama, Student Number: up2021*****,  Contribution: 50%
  - Full Name: Miguel Pedrosa, Student Number: up202108809, Contribution: 50%
## Installation and Execution

### Linux

1. Ensure that SICStus Prolog 4.8 is installed on your system.

2. Clone the repository or download the game files.
   - `git clone <repository-url>` or similar command.
3. Navigate to the game directory.
   - `cd path/to/game`
4. Start SICStus Prolog with the game file.
   - `sicstus -l main.pl`
5. Run the game.
   - `play`

### Windows

1. Ensure that SICStus Prolog 4.8 is installed on your system.

2. Clone the repository or download the game files.
   - Instructions on how to clone/download.
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

### Move Validation and Execution

[Describe the predicate `move/3` for validating and executing a play.]

### List of Valid Moves

[Detail how the list of possible moves is generated with the predicate `valid_moves/3`.]

### End of Game

[Explain the predicate `game_over/2` for checking the end of the game and determining the winner.]

### Game State Evaluation

[Discuss how the game state is evaluated through the `value/3` predicate.]

### Computer Plays

[Describe how the computer selects a move using the `choose_move/4` predicate based on different levels of difficulty.]

## Conclusions

[Discuss the conclusions about the work carried out, limitations of the program, and possible improvements.]

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
