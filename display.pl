:- consult(data).

% display_coordinates_bottom(+Length)
% Displays the pattern '1  2  3  4  ... Length'
% For our board should be dispalyed with length 9
%display_coordinates_bottom(0) :-
%	write(0).

%display_coordinates_bottom(N):-
%	N > 0,
%	N1 is N - 1,
%	display_coordinates_bottom(N1),
%	write(N),
%	write('  ').

% Size of the board
size(10).

% Displays the horizontal bar for the board
display_bar(0):- 
    write('|\n'), !.
display_bar(N):- 
    write('|-----'),
    N1 is N - 1,
    display_bar(N1).

% Displays the header of the board
display_header(0, _):- 
    nl, !.
display_header(N, Size):- 
    (N < 10 -> write('    ') ; write('   ')), % Proper spacing
    write(N),
    N1 is N - 1,
    display_header(N1, Size).

% Display one cell of the board
display_cell:- 
    write('         |').

% Display one row of the board
display_row(_, 0, _):- 
    write('\n'), !.
display_row(Line, Col, Size):- 
    display_cell,
    NextCol is Col - 1,
    display_row(Line, NextCol, Size).

% Display the entire board
display_board(0, _):- 
    !.
display_board(Line, Size):- 
    write(Line), write(' |'),
    display_row(Line, Size, Size),
    display_bar(Size),
    NextLine is Line - 10,
    display_board(NextLine, Size).

% matrix_element(+Matrix, +Row, +Col, -Element)
% Retrieves the Element at position (Row, Col) in the Matrix.
matrix_element(Matrix, Row, Col, Element) :-
    nth0(Row, Matrix, MatrixRow),  % Get the specified row from the matrix
    nth0(Col, MatrixRow, Element).  % Get the specified element from the row

% display_pieces_square(+Board,+Line,+Col)
% Displays the piece at a specified position (Line and Col) on the Board
% If the square is none, display ' ---- '.
display_pieces_square(Board, Line, Col) :-
    matrix_element(Board, Line, Col, none),
    write(' ---- ').
% If the square contains a piece, display the corresponding symbol.
display_pieces_square(Board, Line, Col) :-
    matrix_element(Board, Line, Col, Square),
    square_to_display(Square, Display),
    write(Display).

% Main predicate to display the empty board
show_board:- 
    size(Size),
    display_header(Size, Size),
    write('       '),
    display_bar(Size),
    display_board(90, Size).