require './piece'

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
  end

  def legal_move?(to_position)
    # p @position[0]
    # p @position[1]
    # p to_position[0]
    # p to_position[1]
    move = [@position[0] - to_position[0], @position[1] - to_position[1]]
    if @piece_type == :knight
      return true if KNIGHT_MOVES.include?(move)
    elsif @piece_type == :king
      return true if KING_MOVES.include?(move)
    end

    false
  end
end
