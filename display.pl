% display_coordinates_bottom(+Length)
% Displays the pattern '1  2  3  4  ... Length'
% For our board should be dispalyed with length 9
display_coordinates_bottom(0) :-
	write(0).

display_coordinates_bottom(N):-
	N > 0,
	N1 is N - 1,
	display_coordinates_bottom(N1),
	write(N),
	write('  ').