
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cephalopod is a two player game which employs a 5x5 board, 24 dice of one color, and 24 dice of another color.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% BOARD %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

board([
        [1-2, 2-0, 0-0, 0-0, 0-0],
        [1-2, 2-0, 0-0, 0-0, 0-0],
        [1-2, 2-0, 0-0, 0-0, 0-0],
        [1-2, 2-0, 0-0, 0-0, 0-0],
        [1-2, 2-0, 0-0, 0-0, 0-0]
      ]).


% 1-X -> 1 Represents the white color and the X represents the value of the piece 
% 2-X -> 2 Represents the black color and the X represents the value of the piece 
% 0-0 -> Represents an empty cell 

% Printing Board

cellDivision:- write('|'). 
columns:- write('          |    1    |    2    |    3    |    4    |    5    |').

lineConvert(LineNumber):- write('|    '), write(LineNumber), write('    ').

convertValues(0, 0):- write('         ').                                      %% Empty Cell
convertValues(1, Number):- write(' WHITE-'), write(Number), write(' ').        %% White Cell
convertValues(2, Number):- write(' BLACK-'), write(Number), write(' ').        %% Black Cell
                       
drawBoard([], _).
drawBoard([FirstLine | Rest], Counter):-  
        lineConvert(Counter), 
        showLine(FirstLine), 
        nl, 
        NewCounter is Counter + 1, 
        drawBoard(Rest, NewCounter).

showLine([]):- write('|').
showLine([ColorDie - NumberDie | Rest]):- 
        cellDivision, 
        convertValues(ColorDie,NumberDie), 
        showLine(Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% LOGIC %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

