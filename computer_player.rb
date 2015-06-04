require_relative 'board'

class ComputerPlayer
  def initialize(board, color)
    @board = board
    @color = color
    @moved_pieces = []
  end

  def make_move
    @board.each_piece do |piece|
      if piece.color == @color
        move = piece.valid_moves.first
        if move && !@moved_pieces.include?(piece)
          @moved_pieces << piece
          return [piece.position, move]
        end
      end
    end
    @moved_pieces = [];
    @board.each_piece do |piece|
      if piece.color == @color
        move = piece.valid_moves.first
        if move && !@moved_pieces.include?(piece)
          @moved_pieces << piece
          return [piece.position, move]
        end
      end
    end
  end
end
