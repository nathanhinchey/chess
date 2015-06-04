require_relative 'game'

class ComputerPlayer
  def initialize(board, color)
    @board = board
    @color = color
  end

  def make_move
    @board.each_piece do |piece|
      if piece.color == @color
        move = piece.valid_moves.first
        return [piece.position, move] if move
      end
    end
  end
end
