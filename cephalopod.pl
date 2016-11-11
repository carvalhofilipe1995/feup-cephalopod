

includeUtilities:- include('utilities.pl').
:- use_module(library(lists)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% CEPHALOPOD %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cephalopod is a two player game which employs a 5x5 board, 24 dice of one color, and 24 dice of another color.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% GameBoard %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

board([
        [0-0, 2-3, 1-6, 1-6, 1-6],      % 1-X -> 1 Represents the white color and the X represents the value of the piece
        [1-1, 1-6, 1-1, 1-6, 1-1],      % 2-X -> 2 Represents the black color and the X represents the value of the piece
        [1-6, 1-1, 2-6, 1-6, 1-6],      % 0-0 -> Represents an empty cell
        [1-6, 1-6, 1-6, 1-6, 2-6],
        [1-6, 1-4, 1-6, 2-1, 1-6]
      ]).



runGame:-
  clearScreen(100),
  cephalopod,
  menu,
  read(Choice), nl, write(' >'), Choice > 0, Choice =< 3,
  readChoice(Choice).

readChoice(1):- playGame.
readChoice(2):- clearScreen(100), rules, read(Choice), Choice = 0, runGame.
readChoice(3):- write(' Exiting...').

checkWinner(Board, WhiteDieces, BlackDieces, Winner):- 
        countDieces(Board, 1, WhiteDieces), 
        countDieces(Board, 2, BlackDieces),
        (WhiteDieces > BlackDieces -> Winner = 1 ; Winner = 2).

playGame:- clearScreen(100), cephalopod, gameMode, read(Choice),
           (Choice = 0 ->  runGame; (Choice > 0, Choice < 4 -> startGame(Choice) ; write('Wrong input! Try again!'), playGame)).




     


