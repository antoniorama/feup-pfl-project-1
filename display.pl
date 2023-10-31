matrix_element(Matrix, Row, Col, Element) :-
    nth0(Row, Matrix, MatrixRow), 
    nth0(Col, MatrixRow, Element).

display_pieces_square(Board, Line, Col) :-
    matrix_element(Board, Line, Col, none),
    write('    ').

% If the square contains a piece, display the corresponding symbol.
display_pieces_square(Board, Line, Col) :-
    matrix_element(Board, Line, Col, Square),
    square_to_display(Square, Display),
    write(Display).

% display_square_at(+Line, +Col)
% Displays the piece that is in Line and Col
display_square_at(Line, Col) :-
    board(_, BoardMatrix),
    display_pieces_square(BoardMatrix, Line, Col).

% Display a bar of '+' and '-'
display_bar(0, _) :- write('+\n').

display_bar(Size, Counter) :-
    Size = Counter,
    write('   '),
    write('+----'),
    NewSize is Size - 1,
    display_bar(NewSize, Counter).

display_bar(Size, Counter) :-
    write('+----'),
    NewSize is Size - 1,
    display_bar(NewSize, Counter).

% Display a row of board cells
display_row(Board, Size, RowNum) :-
    format("~d0 ", [RowNum]), 
    display_row_contents(Board, Size, RowNum).

display_row_contents(_, 0, RowNum) :-
    format("| ~d0\n", [9-RowNum]).
    
display_row_contents(Board, Size, RowNum) :-
    ColNum is 10 - Size, 
    write('|'),
    display_pieces_square(Board, RowNum, ColNum),
    NewSize is Size - 1,
    display_row_contents(Board, NewSize, RowNum).

% Display the board
display_board(_, -1, _):-  %
    display_bar(10, _).
display_board(Board, RowNum, Size) :-
    display_bar(Size, Size),
    display_row(Board, Size, RowNum),  
    NewRowNum is RowNum - 1,
    display_board(Board, NewRowNum, Size).

% Display the header coords from N to 0
display_header_coords(-1, _) :- nl.
display_header_coords(Num, Counter) :-
    Num = Counter,
    write(' '),
    NewNum is Num - 1,
    display_header_coords(NewNum, Counter).
display_header_coords(Num, Counter) :-
    format("    ~d", [Num]),
    NewNum is Num - 1,
    display_header_coords(NewNum, Counter).
	
% Display the footer coords from 0 to N
display_footer_coords(N, _):- 
	N < 0.
display_footer_coords(N, Counter) :-
    N = Counter,
    write(' '),
    NewN is N - 1,
    display_footer_coords(NewN, Counter).
display_footer_coords(N, Counter) :-
	N >= 0,
    NewN is N - 1,
    display_footer_coords(NewN, Counter),
	format("    ~d", [N]).
