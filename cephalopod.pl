%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cephalopod is a two player game which employs a 5x5 board, 24 dice of one color, and 24 dice of another color.

board([
        [1-2, 0-0, 0-0, 0-0, 0-0],
        [1-2, 0-0, 0-0, 0-0, 0-0],
        [1-2, 0-0, 0-0, 0-0, 0-0],
        [1-2, 0-0, 0-0, 0-0, 0-0],
        [1-2, 0-0, 0-0, 0-0, 0-0]
      ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% LOGIC %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% BOARD %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1-X -> 1 Represents the white color and the X represents the value of the piece 
% 2-X -> 2 Represents the black color and the X represents the value of the piece 
% 0-0 -> Represents an empty cell 

% Printing Board

convertValues(0,0):- write('').                 %% Empty Cell
convertValues(1,Number):- write(Number).        %% White Cell
convertValues(2,Number):- write(Number).        %% Black Cell
                       
drawBoard([]).
drawBoard([FirstLine | Rest]):- showLine(FirstLine), drawBoard(Rest).

showLine([]).
showLine([ColorDie - NumberDie | Rest]):- convertValues(ColorDie,NumberDie), showLine(Rest).


