
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cephalopod is a two player game which employs a 5x5 board, 24 dice of one color, and 24 dice of another color.

cephalopod:- write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
             write('%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%'), nl,
             write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

menu:- write('          1. Play game'), nl,
       write('          2. Rules'), nl,
       write('          3. Exit'), nl.

gameMode:- write('        1. PLAYER VS PLAYER'), nl,
           write('        2. PLAYER VS PC'), nl,
           write('        3. PC     VS PC'), nl, nl,
           write('    > Press 0 to back to menu'), nl.

rules:-
       cephalopod,
       write('\n> Moves entail in placing an own die on an unoccupied square.'), nl,
       write('> Sometimes it is posible to make captures, deppending on the dice on the adjacent squares (vertically and horizontally adjacent) to the placed die:'), nl,
       write('  - The capture is not possible if the amount of adjacent dice is less than two. In this case the new die must show the value 1.'), nl,
       write('  - If there are two adjacent dice and their sum is less than 7, both are captured, and the new die shows their sum.'), nl,
       write('  - If there are three or four dice, the player can choose which are captured, being at least two of them whose sum is less than 7.'), nl,
       write('  - There is no option to capture when, even if there are two or more adjacent dice, the minimum sum is more than 6. In this case the new die must show the value 1.'), nl,
       write('> Captured dice are returned to their owner, so that they may be used later during the game.'), nl,
       write('> There is no option to pass.'), nl,
       write('> The game ends when the board is filled. Draws are impossible because the number of square is not even.'), nl, nl,
       write('          > Press 0 to back to menu'), nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% BOARD %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

board([
        [0-0, 0-0, 0-0, 0-0, 0-0],      % 1-X -> 1 Represents the white color and the X represents the value of the piece
        [0-0, 0-0, 0-0, 0-0, 0-0],      % 2-X -> 2 Represents the black color and the X represents the value of the piece
        [0-0, 0-0, 0-0, 0-0, 0-0],      % 0-0 -> Represents an empty cell
        [0-0, 0-0, 0-0, 0-0, 0-0],
        [0-0, 0-0, 0-0, 0-0, 0-0]
      ]).

% Printing Board

cellDivision:- write('|').
columns:- write('          |    1    |    2    |    3    |    4    |    5    |\n').

lineConvert(LineNumber):- write('|    '), write(LineNumber), write('    ').

convertValues(0, 0):- write('         ').                                                 %% Empty Cell
convertValues(1, Number):- write('   *'), write(Number), write('*  '), write(' ').        %% White Cell
convertValues(2, Number):- write('   <'), write(Number), write('>  '), write(' ').        %% Black Cell

showBoard(Board):- columns, drawBoard(Board,1).

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

%%%%% -- Changing Board Game -- %%%%%

% Setting Board Game - ADDS Change to the selected Cell %

putDice(1, Col, [H1 | T], Change, [H2 | T]):-
        putDiceAux(Col, H1 , Change, H2).
putDice(Row, Col, [H | T1], Change, [H | T2]):-
        NewRow is Row - 1,
        putDice(NewRow, Col, T1, Change, T2).

putDiceAux(1, [H1|T], Change, L):-
        append(H1, Change, H2),
        append([H2], T, L).
putDiceAux(Col, [H|T1], Change, [H|T2]):-
        NewCol is Col-1,
        putDiceAux(NewCol, T1, Change, T2).

% Getting Cell %

getCell(1, Col, [H | _], Cell):-
        getCellColl(Col, H, Cell).
getCell(Row, Col, [_ | T], Cell):-
                Row > 1, Row < 9,
                Col > 0, Col < 9,
        NewRow is Row - 1,
        getCell(NewRow, Col, T, Cell).

getCellColl(1, [H|_], H).

getCellColl(Col, [_|T1], Cell):-
                Col > 1, Col < 9,
        NewCol is Col-1,
        getCellColl(NewCol, T1, Cell).

% Empty a Cell %

emptyCell(1, Col, [H1 | T], [H2 | T]) :-
        emptyCellCol(Col, H1, H2).
emptyCell(Row, Col, [H | T1], [H | T2]):-
                Row > 1, Row < 9,
        NewRow is Row - 1,
        emptyCell(NewRow, Col, T1, T2).

emptyCellCol(1, [_ | T], [[] | T]).
emptyCellCol(Col, [H | T1], [H | T2]):-
                Col > 1, Col < 9,
        NewCol is Col - 1,
        emptyCellCol(NewCol, T1, T2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% LOGIC %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear Screen %

clearScreen(0).
clearScreen(N):- nl, N1 is N-1, clearScreen(N1).

runGame:-
  clearScreen(100),
  cephalopod,
  menu,
  read(Choice), nl, write(' >'), Choice > 0, Choice =< 3,
  readChoice(Choice).

readChoice(1):- playGame.
readChoice(2):- clearScreen(100), rules, read(Choice), Choice = 0, runGame.
readChoice(3):- write(' Exiting...').

playGame:- clearScreen(100), cephalopod, gameMode, read(Choice),
           (Choice = 0 ->  runGame; (Choice > 0, Choice < 4 -> startGame(Choice) ; write('Wrong input! Try again!'), playGame)).


% Player VS PLAYER

startGame(1):- board(X), playerWhite(X).

playerWhite(Board):-
        clearScreen(100),
        write('-> Whites playing'), nl, nl,
        write('   > Valid Moves: []'), nl, nl,
        showBoard(Board), nl, nl,
        write('   > 1. Put a dice'), nl,
        write('   > 2. Take a dice'), nl, nl,
        read(Choice), Choice > -1, Choice < 3,
        (Choice = 0 -> runGame; playerBlack(Board)).
        % (Choice = 1 -> putWhiteDice(Board) ; takeBlackDice(Board)),
        % playerBlack(Board).

playerBlack(Board):-
        clearScreen(100),
        write('-> Blacks playing'), nl, nl,
        write('   > Valid Moves: []'), nl, nl,
        showBoard(Board), nl, nl,
        write('   > 1. Put a dice'), nl,
        write('   > 2. Take a dice'), nl, nl,
        read(Choice), Choice > -1, Choice < 3,
        nl,
        (Choice = 0 -> runGame; playerWhite(Board)).
        % (Choice = 1 -> putBlackDice(Board) ; takeWhiteDice(Board)),
        % playerWhite(Board).
