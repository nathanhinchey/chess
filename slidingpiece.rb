require 'byebug'
require './piece'

class SlidingPiece < Piece
  def initialize(board, color, position, piece_type)
    @diagonal = false
    @horizontal_and_vertical = false
    super
    @piece_type = piece_type
    @diagonal = true if piece_type == :queen || piece_type == :bishop
    @horizontal_and_vertical = true if piece_type == :rook || piece_type == :queen
  end

  def horiz_or_vert?(to_position)
    # p " horiz_or_vert #{to_position}"
    to_position[0] == @position[0] || to_position[1] == @position[1]

  end

  def diagonal?(to_position)
    # p "diagonal #{to_position}"
    x_diff = to_position[0] - @position[0]
    y_diff = to_position[1] - @position[1]
    if (x_diff == y_diff) || (x_diff == y_diff * (-1))
      true
    else
      false
    end
  end


  def legal_move?(to_position)
    return false unless available_square?(to_position)
    return false unless legal_path?(to_position)
    if @diagonal && diagonal?(to_position)
      true
    elsif @horizontal_and_vertical && horiz_or_vert?(to_position)
      true
    else
      false
    end
  end

  def legal_path?(to_position)
    x_positions = [to_position[0], @position[0]]
    y_positions = [to_position[1], @position[1]]

    # low_x_pos, high_x_pos = x_positions.sort
    # low_y_pos, high_y_pos = y_positions.sort
    if to_position[0] - @position[0] == 0
      difference = to_position[1] - @position[1]
      step_x = 0
      step_y = 1 * (difference / difference.abs)
    else
      difference = to_position[0] - @position[0]
      step_x = 1 * (difference / difference.abs)
      step_y = 0
    end

    (1...difference.abs).each do |step|
      current_square = [@position[0] + step_x * step, @position[1] + step_y * step]
      next if board[current_square].nil? #makes sure squares are empty
      return false
    end




    # ((low_y_pos + 1)...high_y_pos).each do |step|
    #   current_square = [@position[0], step]
    #   next if board[current_square].nil? #makes sure squares are empty
    #   return false
    # end
    # elsif low_y_pos == high_y_pos
    #   ((low_x_pos + 1)...high_x_pos).each do |step|
    #     current_square = [step, @position[1]]
    #     next if board[current_square].nil? #makes sure squares are empty
    #     return false
    #   end

    # else
    #   if to_position[0] - @position[0] == to_position[1] - @position[1]
    #     multiplier = 1
    #   else
    #     multiplier = -1
    #   end
    #   low, high = [1, to_position[0] - @position[0]].sort
    #   (low...high).each do |difference|
    #     current_square = [@position[0] + difference, (@position[1] + difference) * multiplier]
    #     next if board[current_square].nil? #makes sure squares are empty
    #     return false
    #   end
    # end
    true
  end
end
