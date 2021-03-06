require 'byebug'
require_relative 'piece'

class Pawn < Piece

  def initialize(board, color, position, piece_type)
    super
    @color = color
    @direction = -1 if color == :white
    @direction = 1 if color == :black
    @value = 1
  end

  def specific_legal_move?(to_position)
    # p @position
    # p to_position
    x_diff = (to_position[0] - position[0]) * @direction
    y_diff = (to_position[1] - position[1]) * @direction
    if x_diff == 1 && y_diff == 0 && on_board?(to_position) && board[to_position].nil?
      return true
    elsif x_diff == 1 && y_diff == 1 && board[to_position] && board[to_position].color != @color
      return true
    elsif x_diff == 1 && y_diff == -1 && board[to_position] && board[to_position].color != @color
      return true
    elsif (x_diff == 2 && y_diff == 0 && on_board?(to_position) && board[to_position].nil?) && (position[0] == 1 || position[0] == 6)
      return true
    else
      return false
    end
  end

  def valid_moves
    valid_moves_array = []
    x,y = self.position
    test_positions = [
      [x + 1 * @direction, y + 0],
      [x + 1 * @direction, y + 1 * @direction],
      [x + 1 * @direction, y + 1 * @direction],
      [x + 1 * @direction, y + -1 * @direction],
      [x + 2 * @direction, y + 0]
    ]

    test_positions.each do |test_position|
      valid_moves_array << test_position if legal_move?(test_position)
    end

    valid_moves_array
  end
end
