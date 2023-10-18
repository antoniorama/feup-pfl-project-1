% Display a bar of '+' and '-'
display_bar(0) :- write('+\n').
display_bar(Size) :-
    write('+---'),
    NewSize is Size - 1,
    display_bar(NewSize).

% Display a row of board cells
display_row(0, RowNum) :- format("~d\n", [RowNum]).
display_row(Size, RowNum) :-
    write('   |'),
    NewSize is Size - 1,
    display_row(NewSize, RowNum).

% Display the board
display_board(-1, _).
display_board(RowNum, Size) :-
    display_bar(Size),
    display_row(Size, RowNum),
    NewRowNum is RowNum - 1,
    display_board(NewRowNum, Size).

% Display the header
display_header(-1) :- nl.
display_header(Num) :-
    format(' ~d ', [Num]),
    NewNum is Num - 1,
    display_header(NewNum).

% To reverse the board coordinates as displayed in the image
reverse_board_coordinates(Size, NewSize) :-
    NewSize is Size - 1.

% Test with a board of size 10
test_display :-
    Size = 10,
    reverse_board_coordinates(Size, NewSize),
    display_header(NewSize),
    display_board(NewSize, Size).
