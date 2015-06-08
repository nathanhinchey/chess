load 'piece.rb'
load 'board.rb'
load 'pawn.rb'
load 'steppingpiece.rb'
load 'slidingpiece.rb'
load 'game.rb'

board = Board.new
king = SteppingPiece.new(board,:white,[0,0], :king)
board[[0,0]] = king
rook1 = SlidingPiece.new(board, :black,[2,0], :rook)
rook2 = SlidingPiece.new(board, :black,[0,2], :rook)
rook3 = SlidingPiece.new(board, :black,[1,2], :rook)
board[[2,0]] = rook1
board[[0,2]] = rook2
board[[1,2]] = rook3
