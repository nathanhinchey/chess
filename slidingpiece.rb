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

    low_x_pos, high_x_pos = x_positions.sort
    low_y_pos, high_y_pos = y_positions.sort
    if low_x_pos == high_x_pos
      p "low_x_pos == high_x_pos"
      ((low_y_pos + 1)...high_y_pos).each do |step|
        current_square = [@position[0], step]
        p low_y_pos
        p high_y_pos
        next if board[current_square].nil? #makes sure squares are empty
        return false
      end
    elsif low_y_pos == high_y_pos
      ((low_x_pos + 1)...high_x_pos).each do |step|
        current_square = [step, @position[1]]
        next if board[current_square].nil? #makes sure squares are empty
        return false
      end
    else
      if to_position[0] - @position[0] == to_position[1] - @position[1]

        (1...to_position[0] - @position[0]).each do |difference|
          current_square = [@position[0] + difference, @position[1] + difference]
          next if board[current_square].nil? #makes sure squares are empty
          return false
        end
      elsif to_position[0] - @position[0] == -1 * (to_position[1] - @position[1])
        (1...to_position[0] - @position[0]).times do |difference|
          current_square = [@position[0] + difference, @position[1] - difference]
          next if board[current_square].nil? #makes sure squares are empty
          return false
        end
      end
    end
    true
  end


end
