%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cephalopod is a two player game which employs a 5x5 board, 24 dice of one color, and 24 dice of another color.

board([
         [[],[],[],[],[]],
         [[],[],[],[],[]],
         [[],[],[],[],[]],
         [[],[],[],[],[]],
         [[],[],[],[],[]]
      ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% LOGIC %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% BOARD %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Printing Board

drawBoard([]).
drawBoard([FirstLine | Rest]):- showLine(FirstLine), drawBoard(Rest).

showLine([]).
showLine([FirstCell | Rest]):- write(FirstCell), showLine(Rest).


