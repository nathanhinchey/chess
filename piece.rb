class Piece
  attr_accessor :color, :board, :position, :piece_type
  def initialize(board, color, position, piece_type)
    @color = color
    @board = board
    @position = position
    @piece_type = piece_type
  end

  def move!(to_position)
    if board[to_position].nil?
      @position = to_position
    else
      #capture the enemy piece, and put this piece there
      @position = to_position
      board[to_position] = self
    end
  end

  def inspect
    { color: @color,
      position: @position,
      piece_type: @piece_type
    }.inspect
  end


  def available_square?(to_position)
    return false unless on_board?(to_position)
    board[to_position].nil? || board[to_position].color != self.color
  end

  def on_board?(position)
    position[0].between?(0 , 7) && position[1].between?(0 , 7)

  end

  def capture(other_piece)
    print "This piece captured #{other_piece}."
  end

  def dup(new_board)
    new_piece = self.class.new(new_board, color, position, piece_type)
  #  p new_piece.position
  end

  def legal_move?(to_position)
    return false unless specific_legal_move?(to_position)
    return false if board.move_puts_player_in_check?(position, to_position, color)
    true
  end
end
# [[piece object][nil][nil][piece_object]]
