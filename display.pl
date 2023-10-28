:- consult(data).

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
display_bar(0) :- write('+\n').
display_bar(Size) :-
    write('+----'),
    NewSize is Size - 1,
    display_bar(NewSize).

% Display a row of board cells
display_row(Board, Size, 9) :-
    write('00 '),
    display_row_contents(Board, Size, RowNum).

display_row(Board, Size, RowNum) :-
    format("~d ", [90-RowNum*10]), 
    display_row_contents(Board, Size, RowNum).

display_row_contents(Board, 0, RowNum) :-
    format("| ~d0\n", [RowNum]).
    
display_row_contents(Board, Size, RowNum) :-
    ColNum is 10 - Size, 
    write('|'),
    display_pieces_square(Board, RowNum, ColNum),
    NewSize is Size - 1,
    display_row_contents(Board, NewSize, RowNum).

% Display the board
display_board(Board, 10, _):-
    write('   '),
    display_bar(10).
display_board(Board, RowNum, Size) :-
    write('   '),
    display_bar(Size),
    display_row(Board, Size, RowNum),
    NewRowNum is RowNum + 1,
    display_board(Board, NewRowNum, Size).


% Display the header
display_header(-1, _) :- nl.
display_header(Num, MaxNum) :-
    (Num =:= MaxNum -> format("  ~d", [Num]); format('  ~d', [Num])),
    NewNum is Num - 1,
    display_header(NewNum, MaxNum).

% Test with a board of size 10
test_display :-
    board(_, Board),
    Size is 10,
    display_header_coords,
    display_board(Board, 0, Size),
    display_footer_coords.
