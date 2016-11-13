
includeUtilities:- include('utilities.pl').
:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearScreen(0).
clearScreen(N):- nl, N1 is N-1, clearScreen(N1).

%% Cephalopod is a two player game which employs a 5x5 board, 24 dice of one color, and 24 dice of another color.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% GameBoard %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

board([
         [0-100,  0-100,  2-4,  2-4,  0-100],      % 1 - X -> 1 Represents the white color and the X represents the value of the piece
         [2-4,    1-5,    2-4,  1-1,  2-4],      % 2 - X -> 2 Represents the black color and the X represents the value of the piece
         [2-4,    2-4,    2-4,  2-4,  1-1],      % 0 - (100) -> Represents an empty cell
         [2-4,    2-4,    2-4,  1-1,  2-4],
         [2-4,    2-4,    2-4,  2-4,  2-4]
      ]).


startGame:- 
        clearScreen(100), 
        cephalopod, 
        menu, 
        read(Choice),
        nl, 
        write(' >'), Choice > 0, Choice =< 3,
        readChoice(Choice).

readChoice(1):- playGame.
readChoice(2):- clearScreen(100), rules, read(Choice), Choice = 0, runGame.
readChoice(3):- write(' Exiting...').

checkWinner(Board, Winner):- 
        countDices(Board, 1, WhiteDieces), 
        countDices(Board, 2, BlackDieces),
        NumberPieces is WhiteDieces + BlackDieces,
        (NumberPieces = 25 -> (WhiteDieces > BlackDieces -> Winner = 1 ; (WhiteDieces < BlackDieces -> Winner = 2)); Winner = 0).

playGame:- clearScreen(100), cephalopod, gameMode, 
        read(Choice),
        (Choice = 0 ->  startGame
        ; 
         (Choice > 0, Choice < 4 -> initializeGame(Choice) 
         ; 
          write('Wrong input! Try again!'), playGame)).


initializeGame(1):- board(BoardGame), normalGame(1, BoardGame).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Player VS Player %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% White Player

normalGame(1, BoardGame):-
        clearScreen(100),
        checkWinner(BoardGame, Player),
        (Player = 0 ->
         nl, write('   -> **Whites Playing'), nl, nl,
         showBoard(BoardGame), nl,
         validMoves(BoardGame),
         write('   -> Placing a dice'), nl, nl,
         write('      -> Line '),
         read(Line), Line > 0, Line < 6,
         write('      -> Col '),
         read(Col), Col > 0, Col < 6,
         write('      -> Dice Value '),
         read(DiceValue), DiceValue > 0, DiceValue < 7,
         getCell(Line, Col, BoardGame, CellToMove - _),
         (CellToMove \= 0 -> 
          nl, nl, 
          write('  -> This cell is already taken. Try again! Press 0 to continue.'), nl, 
          write('  '), 
          read(Back), 
          Back = 0, 
          normalGame(1, BoardGame)
         ;
          placeDice(BoardGame, Line, Col, NewBoard, DiceValue, 1), 
          length(NewBoard, Change),
          (Change = 5 ->  
           normalGame(2, NewBoard)
          ;  
           nl, nl,
           write('     '),  
           read(Back), 
           Back = 0, 
           normalGame(1, BoardGame)))
        ; 
         (Player = 1 -> 
          clearScreen(100),
          write('   -> **Whites WIN'), nl, nl, 
          showBoard(BoardGame), nl,  
          write('  -> Press 0 to Back to menu. '), 
          read(Back), 
          Back = 0, startGame) 
        ; 
         (Player = 2 ->
          clearScreen(100),
          write('   -> <>Blacks WIN'), nl, nl, 
          showBoard(BoardGame), nl,  
          write('  -> Press 0 to Back to menu. '),  
          read(Back), 
          Back = 0, startGame)).

% Black Player 

normalGame(2, BoardGame):-
        clearScreen(100),
        checkWinner(BoardGame, Player),
        (Player = 0 ->
         nl, write('   -> <>Blacks Playing'), nl, nl,
         showBoard(BoardGame),nl,
         validMoves(BoardGame),
         write('   -> Placing a dice'), nl, nl,
         write('      -> Line '),
         read(Line), Line > 0, Line < 6,
         write('      -> Col '),
         read(Col), Col > 0, Col < 6,
         write('      -> Dice Value '),
         read(DiceValue), DiceValue > 0, DiceValue < 7,
         getCell(Line, Col, BoardGame, CellToMove - _),
         (CellToMove \= 0 -> 
          nl, nl, 
          write('  -> This cell is already taken. Try again! Press 0 to continue.'),
          write('  '), 
          read(Back), 
          Back = 0, 
          normalGame(2, BoardGame)
         ;
          placeDice(BoardGame, Line, Col, NewBoard, DiceValue, 2), 
          length(NewBoard, Change),
          (Change = 5 -> 
           normalGame(1, NewBoard)
          ; 
           nl, nl,
           write('     '), 
           read(Back), 
           Back = 0, 
           normalGame(2, BoardGame)))
        ;
         (Player = 1 ->
          clearScreen(100), 
          write('   -> Congratulations **Whites WIN** <-'), nl, nl, 
          showBoard(BoardGame), nl,  
          write('  -> Press 0 to Back to menu. '), 
          read(Back), 
          Back = 0, startGame) 
        ; 
         (Player = 2 ->
          clearScreen(100),
          write('   -> Congratulations <>Blacks WIN<> <-'), nl, nl, 
          showBoard(BoardGame), nl,  
          write('  -> Press 0 to Back to menu. '), 
          read(Back), 
          Back = 0, startGame)).


placeDice(Board, 1, 1, NewBoard, DiceValue, Player):- 
        getCell(1, 2, Board, _ - RightValue),
        getCell(2, 1, Board, _ - DownValue),
        SumCells is RightValue + DownValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(1, 2, Board, CurrentBoard), 
         emptyCell(2, 1, CurrentBoard, AuxBoard),
         putDice(1, 1, AuxBoard, Player-DiceValue, NewBoard) 
        ;  
         (DiceValue = 1 -> 
          putDice(1, 1, Board, Player-DiceValue, NewBoard) 
         ; 
          nl,nl,write('    -> A non-capturing placement must show a single pip. Press 0 to try again.'))).

placeDice(Board, 1, 5, NewBoard, DiceValue, Player):- 
        getCell(1, 4, Board, _ - LeftValue),
        getCell(2, 5, Board, _ - UpValue),
        SumCells is LeftValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(1, 4, Board, CurrentBoard), 
         emptyCell(2, 5, CurrentBoard, AuxBoard),
         putDice(5, 5, AuxBoard, Player-DiceValue, NewBoard) 
        ;  
         (DiceValue = 1 -> 
          putDice(1, 5, Board, Player-DiceValue, NewBoard) 
         ; 
          nl,nl,write('    -> A non-capturing placement must show a single pip. Press 0 to try again.'))).

placeDice(Board, 5, 1, NewBoard, DiceValue, Player):- 
        getCell(5, 2, Board, _ - RightValue),
        getCell(4, 1, Board, _ - UpValue),
        SumCells is RightValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(1, 2, Board, CurrentBoard), 
         emptyCell(2, 1, CurrentBoard, AuxBoard),
         putDice(1, 1, AuxBoard, Player-DiceValue, NewBoard) 
        ;  
         (DiceValue = 1 -> 
          putDice(5, 1, Board, Player-DiceValue, NewBoard) 
         ; 
          nl,nl,write('    -> A non-capturing placement must show a single pip. Press 0 to try again.'))). 

placeDice(Board, 5, 5, NewBoard, DiceValue, Player):- 
        getCell(5, 4, Board, _ - LeftValue),
        getCell(4, 5, Board, _ - UpValue),
        SumCells is LeftValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(1, 4, Board, CurrentBoard), 
         emptyCell(2, 5, CurrentBoard, AuxBoard),
         putDice(5, 5, AuxBoard, Player-DiceValue, NewBoard) 
        ;  
         (DiceValue = 1 -> 
          putDice(5, 5, Board, Player-DiceValue, NewBoard) 
         ; 
          nl,nl,write('    -> A non-capturing placement must show a single pip. Press 0 to try again.'))). 

placeDice(Board, 1, Col, NewBoard, DiceValue, Player):-
        RightCol is Col + 1,
        LeftCol is Col - 1,
        getCell(1, RightCol, Board, _ - RightValue),
        getCell(1, LeftCol, Board, _ - LeftValue),
        getCell(2, Col, Board, _ - DownValue),
        SumCells is RightValue + DownValue + LeftValue,
        SumCellsDownRight is RightValue + DownValue,
        SumCellsDownLeft is LeftValue + DownValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(1, RightCol, Board, AuxBoard1), 
         emptyCell(1, LeftCol, AuxBoard1, AuxBoard2),
         emptyCell(2, Col, AuxBoard2, CurrentBoard),
         putDice(1, Col, CurrentBoard, Player-DiceValue, NewBoard) 
        ;  
         (SumCellsDownRight = DiceValue -> 
          emptyCell(1, RightCol, Board, AuxBoard1), 
          emptyCell(2, Col, AuxBoard1, CurrentBoard),
          putDice(1, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsDownLeft = DiceValue -> 
          emptyCell(1, LeftCol, Board, AuxBoard1), 
          emptyCell(2, Col, AuxBoard1, CurrentBoard),
          putDice(1, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          (DiceValue = 1 -> 
           putDice(1, Col, Board, Player-DiceValue, NewBoard) 
          ; 
           nl,nl,write('    -> A non-capturing placement must show a single pip. Press 0 to try again.')))). 

placeDice(Board, Line, 1, NewBoard, DiceValue, Player):-
        UpLine is Line - 1,
        DownLine is Line + 1,
        getCell(UpLine, 1, Board, _ - UpValue),
        getCell(DownLine, 1, Board, _ - DownValue),
        getCell(Line, 2, Board, _ - RightValue),
        SumCells is RightValue + DownValue + UpValue,
        SumCellsRightDown is RightValue + DownValue,
        SumCellsRightUp is RightValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(UpLine, 1, Board, AuxBoard1), 
         emptyCell(DownLine, 1, AuxBoard1, AuxBoard2),
         emptyCell(Line, 2, AuxBoard2, CurrentBoard),
         putDice(Line, 1, CurrentBoard, Player-DiceValue, NewBoard) 
        ;  
         (SumCellsRightUp = DiceValue -> 
          emptyCell(UpLine, 1, Board, AuxBoard1), 
          emptyCell(Line, 2, AuxBoard1, CurrentBoard),
          putDice(Line, 1, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsRightDown = DiceValue -> 
          emptyCell(DownLine, 1, Board, AuxBoard1), 
          emptyCell(Line, 2, AuxBoard1, CurrentBoard),
          putDice(Line, 1, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          (DiceValue = 1 -> 
           putDice(Line, 1, Board, Player-DiceValue, NewBoard) 
          ; 
           nl,nl,write('    -> A non-capturing placement must show a single pip. Press 0 to try again.')))).


placeDice(Board, 5, Col, NewBoard, DiceValue, Player):-
        RightCol is Col + 1,
        LeftCol is Col - 1,
        getCell(5, RightCol, Board, _ - RightValue),
        getCell(5, LeftCol, Board, _ - LeftValue),
        getCell(4, Col, Board, _ - UpValue),
        SumCells is RightValue + UpValue + LeftValue,
        SumCellsUpRight is RightValue + UpValue,
        SumCellsUpLeft is LeftValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(5, RightCol, Board, AuxBoard1), 
         emptyCell(5, LeftCol, AuxBoard1, AuxBoard2),
         emptyCell(4, Col, AuxBoard2, CurrentBoard),
         putDice(5, Col, CurrentBoard, Player-DiceValue, NewBoard) 
        ;  
         (SumCellsUpRight = DiceValue -> 
          emptyCell(5, RightCol, Board, AuxBoard1), 
          emptyCell(4, Col, AuxBoard1, CurrentBoard),
          putDice(1, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsUpLeft = DiceValue -> 
          emptyCell(5, LeftCol, Board, AuxBoard1), 
          emptyCell(4, Col, AuxBoard1, CurrentBoard),
          putDice(5, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          (DiceValue = 1 -> 
           putDice(5, Col, Board, Player-DiceValue, NewBoard) 
          ; 
           nl, nl, write('    -> A non-capturing placement must show a single pip. Press 0 to try again.')))).

placeDice(Board, Line, 5, NewBoard, DiceValue, Player):-
        UpLine is Line - 1,
        DownLine is Line + 1,
        getCell(UpLine, 5, Board, _ - UpValue),
        getCell(DownLine, 5, Board, _ - DownValue),
        getCell(Line, 4, Board, _ - LeftValue),
        SumCells is LeftValue + DownValue + UpValue,
        SumCellsLeftDown is LeftValue + DownValue,
        SumCellsLeftUp is LeftValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(UpLine, 5, Board, AuxBoard1), 
         emptyCell(DownLine, 5, AuxBoard1, AuxBoard2),
         emptyCell(Line, 4, AuxBoard2, CurrentBoard),
         putDice(Line, 5, CurrentBoard, Player-DiceValue, NewBoard) 
        ;  
         (SumCellsLeftUp = DiceValue -> 
          emptyCell(UpLine, 5, Board, AuxBoard1), 
          emptyCell(Line, 4, AuxBoard1, CurrentBoard),
          putDice(Line, 5, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsLeftDown = DiceValue -> 
          emptyCell(DownLine, 5, Board, AuxBoard1), 
          emptyCell(Line, 4, AuxBoard1, CurrentBoard),
          putDice(Line, 5, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          (DiceValue = 1 -> 
           putDice(Line, 5, Board, Player-DiceValue, NewBoard) 
          ; 
           nl,nl,
           write('    -> A non-capturing placement must show a single pip. Press 0 to try again.')))).

placeDice(Board, Line, Col, NewBoard, DiceValue, Player):-
        RightCell is Col + 1,
        LeftCell is Col - 1,
        UpCell is Line - 1,
        DownCell is Line + 1,
        getCell(Line, RightCell, Board, _ - RightValue),
        getCell(Line, LeftCell, Board, _ - LeftValue),
        getCell(DownCell, Col, Board, _ - DownValue),
        getCell(UpCell, Col, Board, _ - UpValue),
        SumCells is RightValue + DownValue + LeftValue + UpValue,
        SumCellsDownRight is RightValue + DownValue,
        SumCellsDownLeft is LeftValue + DownValue,
        SumCellsUpRight is RightValue + UpValue,
        SumCellsUpLeft is LeftValue + UpValue,
        (SumCells =< 6, DiceValue = SumCells -> 
         emptyCell(Line, RightCell, Board, AuxBoard1), 
         emptyCell(Line, LeftCell, AuxBoard1, AuxBoard2),
         emptyCell(UpCell, Col, AuxBoard2, AuxBoard3),
         emptyCell(UpCell, Col, AuxBoard3, CurrentBoard),
         putDice(Line, Col, CurrentBoard, Player-DiceValue, NewBoard) 
        ;  
         (SumCellsDownRight = DiceValue -> 
          emptyCell(Line, RightCell, Board, AuxBoard1), 
          emptyCell(DownCell, Col, AuxBoard1, CurrentBoard),
          putDice(1, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsDownLeft = DiceValue -> 
          emptyCell(Line, LeftCell, Board, AuxBoard1), 
          emptyCell(DownCell, Col, AuxBoard1, CurrentBoard),
          putDice(Line, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsUpRight = DiceValue -> 
          emptyCell(Line, RightCell, Board, AuxBoard1), 
          emptyCell(UpCell, Col, AuxBoard1, CurrentBoard),
          putDice(Line, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          SumCellsUpLeft = DiceValue -> 
          emptyCell(Line, LeftCell, Board, AuxBoard1), 
          emptyCell(UpCell, Col, AuxBoard1, CurrentBoard),
          putDice(Line, Col, CurrentBoard, Player-DiceValue, NewBoard) 
         ; 
          (DiceValue = 1 -> 
           putDice(Line, Col, Board, Player-DiceValue, NewBoard) 
          ; 
           nl,nl,
           write('    -> A non-capturing placement must show a single pip. Press 0 to try again.')))).



% -> Valid Moves <- %


validMoves(Board):-
        write('    %%%%%%%%%% Valid Moves %%%%%%%%%%'),
        nl, nl,
        write('   -> In these empty Cells you should play a single pip (non-capturing placement) or the pip sum of the adjacent dices.'),
        getEmptyCellsLine(Board, 1, 1, Line1),
        getEmptyCellsLine(Board, 2, 1, Line2),
        getEmptyCellsLine(Board, 3, 1, Line3),
        getEmptyCellsLine(Board, 4, 1, Line4),
        getEmptyCellsLine(Board, 5, 1, Line5),
        append([Line1, Line2, Line3, Line4, Line5], [], ValidMoves), 
        nl , nl,
        write('         Moves: '), 
        write(ValidMoves),
        nl, nl.


