
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Utilities %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -- Interface Outputs -- %

cephalopod:- write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl,
             write('%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%'), nl,
             write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'), nl.

menu:- write('          1. Play game'), nl,
       write('          2. Rules'), nl,
       write('          3. Exit'), nl.

gameMode:- write('        1. PLAYER VS PLAYER'), nl,
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


% -- Printing and changing boardgame -- %

cellDivision:- write('|').
columns:- write('          |    1    |    2    |    3    |    4    |    5    |\n').

lineConvert(LineNumber):- write('|    '), write(LineNumber), write('    ').

convertValues(0, 100):- write('         ').                                                 %% Empty Cell
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

putDice(1, Col, [H1 | T], Color-Value, [H2 | T]):-
        putDiceAux(Col, H1 , Color-Value, H2).
putDice(Row, Col, [H | T1], Color-Value, [H | T2]):-
        NewRow is Row - 1,
        putDice(NewRow, Col, T1, Color-Value, T2).

putDiceAux(1,[_ | T], Color-Value, L):-
        append([], [Color-Value], H2),
        append(H2, T, L).
putDiceAux(Col, [H|T1], Color-Value, [H|T2]):-
        NewCol is Col-1,
        putDiceAux(NewCol, T1, Color-Value, T2).


% Getting Cell %

getCell(1, Col, [H | _], Color-Value):-
        getCellColl(Col, H, Color-Value).
getCell(Row, Col, [_ | T], Cell):-
        Row > 1, Row < 9,
        Col > 0, Col < 9,
        NewRow is Row - 1,
        getCell(NewRow, Col, T, Cell).

getCellColl(1, [Color-Value|_], Color-Value).
getCellColl(Col, [_|T1], Color-Value):-
        Col > 1, Col < 9,
        NewCol is Col-1,
        getCellColl(NewCol, T1, Color-Value).


% Empty a Cell %

emptyCell(1, Col, [H1 | T], [H2 | T]) :-
        emptyCellCol(Col, H1, H2).
emptyCell(Row, Col, [H | T1], [H | T2]):-
        Row > 1, Row < 9,
        NewRow is Row - 1,
        emptyCell(NewRow, Col, T1, T2).

emptyCellCol(1, [_ | T], [0- (100) | T]).
emptyCellCol(Col, [H | T1], [H | T2]):-
        Col > 1, Col < 9,
        NewCol is Col - 1,
        emptyCellCol(NewCol, T1, T2).


% Checks if the board is full of dieces a Cell %

isBoardFilled([]).
isBoardFilled([FirstLine | Rest]):- isLineFilled(FirstLine), isBoardFilled(Rest).

isLineFilled([]).
isLineFilled([Color - _ | Rest]):- Color \= 0 -> isLineFilled(Rest) ; fail.


% Checks how many dieces are on board for a Player %

countDices([], _, 0).
countDices([FirstLine | Rest], Player, Counter):- 
        countDices(Rest, Player, NewCounter),
        countDicesLine(FirstLine, Player, PiecesLine),
        Counter is PiecesLine + NewCounter.

countDicesLine([], _, 0).
countDicesLine([Player - _ | Rest], Player, Counter):- countDicesLine(Rest, Player, NewCounter), Counter is NewCounter + 1.
countDicesLine([_ - _ | Rest], Player, Counter):- countDicesLine(Rest, Player, Counter).


% Gets all empty Cells %

checkIfCellIsEmpty(Board, X, Y):- getCell(X, Y, Board, 0-100).

getEmptyCellsLine(_, _, 6, []).

getEmptyCellsLine(Board, Line, Col, [Line-Col | Result]):-
        checkIfCellIsEmpty(Board, Line, Col),
        !,
        NewCol is Col + 1,
        getEmptyCellsLine(Board, Line, NewCol, Result).

getEmptyCellsLine(Board, Line, Col, Result):-
        NewCol is Col + 1,
        getEmptyCellsLine(Board, Line, NewCol, Result).



