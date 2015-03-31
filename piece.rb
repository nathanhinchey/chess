class Piece
  attr_accessor :color, :board, :position
  def initialize(board, color, position)
    @color = color
    @board = board
    @position = position
  end

  def move(to_position)
    if legal_move?(to_position)
      if board[to_position].nil?
        #move there
        @position = to_position
      else
        #capture the enemy piece, and put this piece there
        @position = to_position
        capture(board[to_position])
      end
    else
      raise "Invalid move"
    end
  end



  def available_square?(to_position)
    board[to_position].nil? || board[to_position].color != self.color
  end

  def on_board?(position)
    position[0].between?(0 , 7) && position[1].between?(0 , 7)

  end

  def capture(other_piece)
    print "This piece captured #{other_piece}."
  end
end

class SlidingPiece < Piece
  def initialize(board, diagonal = false, horizontal_and_vertical = false, color, position)
    @diagonal = diagonal
    @horizontal_and_vertical = horizontal_and_vertical
    super(board, color, position)
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
    # TODO make sure it's a legal direction
    x_positions = [to_position[0], @position[0]]
    y_positions = [to_position[1], @position[1]]

    low_x_pos, high_x_pos = x_positions.sort
    low_y_pos, high_y_pos = y_positions.sort

    ((low_y_pos + 1)...high_y_pos).each do |step|
      current_square = [@position[0] + step, @position[1] + step]
      next if board[current_square].nil? #makes sure squares are empty
      return false
    end

    true
  end


end
# [[piece object][nil][nil][piece_object]]


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
    [ 0, 0],
    [ 0, 1],
    [ 1,-1],
    [ 1, 0],
    [ 1, 1]
  ]

  def initialize(board, type_of_piece, color, position)
    @type_of_piece = type_of_piece
    super(board, color, position)
  end

  def legal_move?(to_position)
    move = [@position[0] - to_position[0], @position[1] - to_position[1]]
    if @type_of_piece == :knight
      return true if KNIGHT_MOVES.include?(move)
    elsif @type_of_piece == :king
      return true if KING_MOVES.include?(move)
    end

    false
  end
end

class Board

  attr_reader :board

  def initialize
    @board = Array.new(8) {Array.new(8)}
  end

  def [](pos)
    x,y = pos
    @board[x][y]
  end
  def []=(pos, value)
    x, y = pos
    @board[x][y] = value
  end

end
