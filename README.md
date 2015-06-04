#Ruby Chess
This is console chess game with computer AI player. It makes use of Ruby's capabilities for polymorphism, as well as custom functions to simplify chess tasks.

##Installation
Download this zip and run `ruby game.rb` to play in the console. The interface uses a simplified form of [algebraic notation](http://en.wikipedia.org/wiki/Algebraic_notation_(chess)). To enter a move, enter the piece's start position and its end position separated by a colon, e.g. `a2:a4`. I selected this interface because is unambiguous, simpler to learn than complete algebraic notation, and similar enough that it should be familiar to most people familiar with chess notations.

##Separation of concerns
Each class follows the Law of Demeter, and only interacts with objects one level removed.

##Board class
The board class holds onto position information, and calculates whether a given move will result in a check condition for the board. To do this, it uses a custom iteration function (`Board#each_piece`) to iterate through its pieces.

##Piece class
The piece class is the parent class for each of the other piece types. It has three child classes. The Piece class has several functions available in all cases, and all its children have the same API, although they may have different implementations. An interesting part of the piece class was the `valid_moves` function, which returns an array of all legal moves. The board class relies on this array to calculate whether a current board state is check or not, as well as whether a given board state is checkmate. `valid_moves` completes in 0(1) time for each piece, making a check for checkmate 0(n) where *n* is the number of pieces on the board.
###Pawn
Pawns are distinct from all other pieces in that their move structure is variable. It makes sense for them to inherit from Piece, because it has many functions in common, and also its API needs to be the same. It is not a SteppingPiece because enough of the logic differed that inheritance would have been messy

###SteppingPiece (king, knight)
Stepping pieces consist of kings and knights. These two pieces do not get their own classes, instead holding onto slightly different values and a symbol indicating their type (`:king` and `:knight`). Stepping pieces rely on a finite set of possible vectors from their given position to calculate legal move positions.

##SlidingPiece (bishop, rook, queen)
Sliding pieces, like stepping pieces, are divided by attributes rather than being separate classes. They have enough in common that making a separate class seemed unnecessary. Their legal moves are calculated by a direction vector, as well as a legal_path function that determines whether any pieces are blocking its path.

##Game class
The game includes all the UI. It runs a loop until either the user enters `exit` or one of the players achieves checkmate. The game class calls board, and asks board to move pieces how the user indicates.

##Computer Player
The computer player checks all valid moves it can make, and selects the move that results in the highest [value](http://en.wikipedia.org/wiki/Chess_piece_relative_value) capture, or selects am arbitrary legal non-capture move. 
