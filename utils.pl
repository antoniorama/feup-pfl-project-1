% place_in_matrix(+Matrix, +X, +Y, +NewValue, -NewMatrix)
% places / replaces NewValue in matrix in position (X,Y)
place_in_matrix(Matrix, X, Y, NewValue, NewMatrix):-
    nth0(X, Matrix, OldRow),
    place_in_list(OldRow, Y, NewValue, NewRow),
    place_in_list(Matrix, X, NewRow, NewMatrix).

% place_in_list(+List, +Index, +Value, -NewList)
% places / replaces Value in list in index X
place_in_list(List, Index, Value, NewList):-
    nth0(Index, List, _, Rest),
    nth0(Index, NewList, Value, Rest).

% calculate_position(+Player, +StartPos, -X, -Y)
calculate_position(light_player, StartPos, X, Y):- 
    X is StartPos // 10,
    Y is StartPos mod 10.

calculate_position(dark_player, StartPos, X, Y):- 
    DarkPos is 99 - StartPos,
    X is DarkPos // 10,
    Y is DarkPos mod 10.

calculate_position_new(light_player, StartPos, X, Y):-
    Y is StartPos // 10,
    X is StartPos mod 10.

% calculate_pos_to_pos(+Player, +Pos, -NewPos)
calculate_pos_to_pos(light_player, Pos, NewPos):-
    NewPos is Pos.

calculate_pos_to_pos(dark_player, Pos, NewPos):-
    NewPos is 99 - Pos.

% delete_element_from_list(+Element, +List, -NewList)
delete_element_from_list(Element, List, NewList) :-
    select(Element, List, NewList).

% base case: no more sublists
collect_first_elements([], []).

% recursive case: collect the first element of the head sublist and proceed with the tail
collect_first_elements([[First|_] | RestSublists], [First | RestFirstElements]) :-
    collect_first_elements(RestSublists, RestFirstElements).

% Helper predicate that finds N_Squares for a single piece.
piece_n_squares(PieceName, N_Squares) :-
    piece_info(N_Squares, _, _, _, PieceName).

% Base case: an empty list of pieces results in an empty list of N_Squares.
list_n_squares([], []).

% Recursive case: for a non-empty list of pieces, find the N_Squares for the head
% and recursively process the tail.
list_n_squares([PieceName | RestPieces], [N_Squares | RestNsquares]) :-
    piece_n_squares(PieceName, N_Squares),
    list_n_squares(RestPieces, RestNsquares).


% read_number(-Number)
% Unifies Number with input number from console
read_number(X):-
    read_number_aux(X,0).

read_number_aux(X,Acc):- 
    get_code(C),
    C >= 48,
    C =< 57,
    !,
    Acc1 is 10*Acc + (C - 48),
    read_number_aux(X,Acc1).
read_number_aux(X,X).

% prints the elements of a list (to help debug)
print_list([]). 

print_list([Head|Tail]) :- 
    write(Head),           
    nl,                    
    print_list(Tail).      

% clear_buffer.
% Clears the input buffer.
clear_buffer:-
    repeat,
    get_char(C),
    C = '\n',
    !.

% clear_console/0
% Clears the console
clear_console:-
    write('\33\[2J').