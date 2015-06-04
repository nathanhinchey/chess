require_relative 'piece'

class SteppingPiece < Piece

  KNIGHT_MOVES = [
    [-1, 2],
    [-1,-2],
    [ 1,-2],
    [ 1, 2],
    [-2, 1],
    [-2,-1],
    [ 2, 1],
    [ 2,-1]
  ]

  KING_MOVES = [
    [-1,-1],
    [-1, 0],
    [-1, 1],
    [ 0,-1],
    [ 0, 1],
    [ 1,-1],
    [ 1, 0],
    [ 1, 1]
  ]

  def initialize(board, color, position, type_of_piece)
    super
    @value = 3 if type_of_piece == :knight
  end

  def specific_legal_move?(to_position)
    return false unless available_square?(to_position)

    move = [@position[0] - to_position[0], @position[1] - to_position[1]]
    if @piece_type == :knight
      return true if KNIGHT_MOVES.include?(move)
    elsif @piece_type == :king
      return true if KING_MOVES.include?(move)
    end

    false
  end

  def valid_moves
    valid_moves_array = []
    if piece_type == :knight
      KNIGHT_MOVES.each do |move|
        if legal_move?([position[0] + move[0], position[1] + move[1]])

          valid_moves_array << [position[0] + move[0], position[1] + move[1]]
        end
      end
    else
      KING_MOVES.each do |move|
        if legal_move?([@position[0] + move[0], @position[1] + move[1]])
          valid_moves_array << [@position[0] + move[0], @position[1] + move[1]]
        end
      end
    end

    valid_moves_array
  end
end
