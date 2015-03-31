class Piece
  attr_accessor :color, :board, :position, :piece_type
  def initialize(board, color, position, piece_type)
    @color = color
    @board = board
    @position = position
    @piece_type = piece_type
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

    def inspect
      "#{@color} #{@position} #{@piece_type}"
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
  def initialize(board, color, position, piece_type)
    @diagonal = false
    @horizontal_and_vertical = false
    super
    @piece_type = piece_type
    @diagonal = true if piece_type == :queen || piece_type == :bishop
    @horizontal_and_vertical = true if piece_type == :rook || piece_type == :queen
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



class Pawn < Piece
  def initialize(board, color, position, piece_type)
    super
    @color = color
    @direction = -1 if color == :white
    @direction = 1 if color == :black
  end

  def legal_move?(to_position)
    x_diff = (to_position[0] - position[0]) * @direction
    y_diff = (to_position[1] - position[1]) * @direction
    if x_diff == 1 && y_diff == 0 && board[to_position].nil?
      return true
    elsif x_diff == 1 && y_diff == 1 && board[to_position].color != @color
      return true
    elsif x_diff == 1 && y_diff == -1 && board[to_position].color != @color
      return true
    elsif (x_diff == 2 && y_diff == 0 && board[to_position].nil?) && (@position[0] == 1 || @position[0] == 6)
      return true
    else
      return false
    end

  end

end

class Board

  HASH_PIECES = {white: {
    king: '♔',
    queen: '♕',
    rook: '♖',
    bishop: '♗',
    knight: '♘',
    pawn: '♙'
  }, black: {
    king: '♚',
    queen: '♛',
    rook: '♜',
    bishop: '♝',
    knight: '♞',
    pawn: '♟'
  }}

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

  def king_position(color)
    board.each do |row|
      row.each do |piece|
        if piece && piece.piece_type == :king && piece.color == color
          return piece.position
        end
      end
    end
  end

  def in_check?(color)
    board.each do |row|
      row.each do |piece|
        if piece && piece.legal_move?(king_position(color)) && piece.color != color
          return true
        end
      end
    end
    false
  end

  def move(start_pos, end_pos)
    if self[start_pos]
      self[start_pos].move(end_pos)
      self[start_pos], self[end_pos] = nil, self[start_pos]
    end
    # rescue
    #   puts "Invalid move (board)"
  end

  def print_board
    board.each do |row|
      print "\n"
      row.each do |piece|
        print HASH_PIECES[piece.color][piece.piece_type] if piece
        print "_" if piece.nil?
        print " "
      end
    end

    nil
  end

  def self.starting_board
    board = Board.new

    #black pieces
    board[[0,0]] = SlidingPiece.new(board, :black, [0,0], :rook)
    board[[0,1]] = SteppingPiece.new(board, :black, [0,1], :knight)
    board[[0,2]] = SlidingPiece.new(board, :black, [0,2], :bishop)
    board[[0,3]] = SlidingPiece.new(board, :black, [0,3], :queen)
    board[[0,4]] = SteppingPiece.new(board, :black, [0,4], :king)
    board[[0,5]] = SlidingPiece.new(board, :black, [0,5], :bishop)
    board[[0,6]] = SteppingPiece.new(board, :black, [0,6], :knight)
    board[[0,7]] = SlidingPiece.new(board, :black, [0,7], :rook)

    # black pawns
    8.times do |y|
      board[[1, y]] = Pawn.new(board, :black, [1, y], :pawn)
    end

    # white pieces
    board[[7,0]] = SlidingPiece.new(board, :white, [7,0], :rook)
    board[[7,1]] = SteppingPiece.new(board, :white, [7,1], :knight)
    board[[7,2]] = SlidingPiece.new(board, :white, [7,2], :bishop)
    board[[7,3]] = SlidingPiece.new(board, :white, [7,3], :queen)
    board[[7,4]] = SteppingPiece.new(board, :white, [7,4], :king)
    board[[7,5]] = SlidingPiece.new(board, :white, [7,5], :bishop)
    board[[7,6]] = SteppingPiece.new(board, :white, [7,6], :knight)
    board[[7,7]] = SlidingPiece.new(board, :white, [7,7], :rook)

    #white pawns
    8.times do |y|
      board[[6, y]] = Pawn.new(board, :white, [6, y], :pawn)
    end

    board
  end

end


class Game

  TRANSLATION_HASH = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7,

    "1" => 7,
    "2" => 6,
    "3" => 5,
    "4" => 4,
    "5" => 3,
    "6" => 2,
    "7" => 1,
    "8" => 0
  }

  def initialize
    @board = Board.starting_board


  end

  def play
    loop do
      @board.print_board

      puts "White's turn to move."
      from_pos, to_pos = get_move
      p from_pos
      p to_pos
      @board.move(from_pos, to_pos)
    end
  end

  def get_move
    puts "Enter a move "
    from_position, to_position = gets.chomp.split(":")
    from_col = TRANSLATION_HASH[from_position[0]]
    from_row = TRANSLATION_HASH[from_position[1]]
    to_col = TRANSLATION_HASH[to_position[0]]
    to_row = TRANSLATION_HASH[to_position[1]]

    [[from_row,from_col],[to_row,to_col]]
  end


end
