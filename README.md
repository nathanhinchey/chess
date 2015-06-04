#Ruby Chess
This is console chess game with computer AI player.

##Installation
Download this zip and run `ruby game.rb` to play in the console.

##Separation of concerns
Each class follows the Law of Demeter, and only interacts with objects one level removed.

##Board class
The board class holds onto position information, and calculates whether a given move will result in a check condition for the board. To do this, it uses a custom iteration function (`Board#each_piece`) to iterate through its 

##Computer Player
The computer player
