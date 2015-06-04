require 'byebug'
require_relative 'piece'

class SlidingPiece < Piece

  DIRECTIONS = [
    [-1,-1],
    [-1, 0],
    [-1, 1],
    [ 0,-1],
    [ 0, 1],
    [ 1,-1],
    [ 1, 0],
    [ 1, 1]
  ]

  def initialize(board, color, position, piece_type)
    @diagonal = false
    @horizontal_and_vertical = false
    super
    @piece_type = piece_type
    @diagonal = true if piece_type == :queen || piece_type == :bishop
    @horizontal_and_vertical = true if piece_type == :rook || piece_type == :queen
    piece_value(@piece_type)
  end

  def piece_value(piece_type)
    case piece_type
    when :queen
      @value = 9
    when :bishop
      @value = 3
    when :rook
      @value = 5
    end
    @value
  end

  def horiz_or_vert?(to_position)
    to_position[0] == @position[0] || to_position[1] == @position[1]
  end

  def diagonal?(to_position)
    x_diff = to_position[0] - @position[0]
    y_diff = to_position[1] - @position[1]
    if (x_diff == y_diff) || (x_diff == y_diff * (-1))
      true
    else
      false
    end
  end


  def specific_legal_move?(to_position)
    return false unless available_square?(to_position)
    return false unless legal_path?(to_position)
    if @diagonal && diagonal?(to_position) && legal_diag_path?(to_position)
      true
    elsif @horizontal_and_vertical && horiz_or_vert?(to_position) && legal_horiz_vert_path?(to_position)
      true
    else
      false
    end
  end

  def legal_path?(to_position)
    return legal_diag_path?(to_position) if diagonal?(to_position)
    return legal_horiz_vert_path?(to_position) if horiz_or_vert?(to_position)
  end

  def legal_horiz_vert_path?(to_position)

    if to_position[0] - @position[0] == 0
      difference = to_position[1] - @position[1]
      step_x, step_y = 0, 1 * (difference / difference.abs)
    else
      difference = to_position[0] - @position[0]
      step_x, step_y = 1 * (difference / difference.abs), 0
    end

    (1...difference.abs).each do |step|
      current_square = [@position[0] + step_x * step, @position[1] + step_y * step]
      return false unless board[current_square].nil? #makes sure squares are empty
    end
    true
  end

  def valid_moves
    legal_moves_array = []
    #board[position] #where we start
    DIRECTIONS.each do |direction|

      move_OK = true
      multiplier = 1
      while move_OK
        x_dir, y_dir = direction[0] * multiplier, direction[1] * multiplier
        if legal_move?([position[0] + x_dir, position[1] + y_dir])
          legal_moves_array << [position[0] + x_dir, position[1] + y_dir]
          multiplier += 1
        else
          move_OK = false
        end
      end
    end

    legal_moves_array
  end



  def legal_diag_path?(to_position)
    if to_position[0] - @position[0] == to_position[1] - @position[1]
      multiplier = 1
    else
      multiplier = -1
    end
    low, high = [0, to_position[0] - @position[0]].sort
    (low + 1...high).each do |difference|
      current_square = [@position[0] + difference, (@position[1] + difference * multiplier)]
      next if board[current_square].nil? #makes sure squares are empty
      return false
    end
  true
  end

end
