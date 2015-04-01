require './piece'

class Pawn < Piece
  def initialize(board, color, position, piece_type)
    super
    @color = color
    @direction = -1 if color == :white
    @direction = 1 if color == :black
  end

  def legal_move?(to_position)
    #0p @position
    #p to_position
    x_diff = (to_position[0] - position[0]) * @direction
    y_diff = (to_position[1] - position[1]) * @direction
    if x_diff == 1 && y_diff == 0 && board[to_position].nil?
      return true
    elsif x_diff == 1 && y_diff == 1 && board[to_position].color != @color
      return true
    elsif x_diff == 1 && y_diff == -1 && board[to_position].color != @color
      return true
    elsif (x_diff == 2 && y_diff == 0 && board[to_position].nil?) && (position[0] == 1 || position[0] == 6)
      return true
    else
      return false

    end

  end

end
