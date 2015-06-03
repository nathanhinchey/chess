require_relative 'slidingpiece'
require_relative 'steppingpiece'
require_relative 'pawn'

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
    return nil if x > 7
    board[x][y]
  end
  def []=(pos, value)
    x, y = pos
    board[x][y] = value
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
        if piece && piece.specific_legal_move?(king_position(color))
          return true
        end
      end
    end
    false
  end

  def checkmate?(color)
    return false unless in_check?(color)
    board.each do |row|
      row.each do |piece|
        next if piece.nil?
        p piece
        if piece.color == color && piece.valid_moves.empty?
          checkmate = true
        else
          return false
        end
      end
    end
    checkmate
  end

  def move_puts_player_in_check?(from_pos, to_pos, color)
    board_copy = self.dup
    board_copy.print_board
    board_copy.move(from_pos, to_pos, color)
    board_copy.print_board
    board_copy.in_check?(color)

  end

  def make_legal_move(from_pos, to_pos, color)
    if move_puts_player_in_check?(from_pos, to_pos, color)
      return false
    elsif !self.board[from_pos].specific_legal_move?(to_pos)
      return false
    else
      self.move(from_pos, to_pos, color)
      true
    end
  end

  def move(from_pos, to_pos, color)
    if self[from_pos] && self[from_pos].color == color
      self[from_pos].move!(to_pos)
      self[from_pos], self[to_pos] = nil, self[from_pos]
      true
    else
      false
    end
  end

  def print_board
    print_letter
    board.each_with_index do |row, row_number|
      print "\n"
      print ((row_number - 8).abs).to_s + " "
      row.each do |piece|
        print HASH_PIECES[piece.color][piece.piece_type] if piece
        print "_" if piece.nil?
        print " "
      end
      print ((row_number - 8).abs).to_s
    end

    print "\n"
    print_letter
    print "\n\n"
    nil
  end

  def print_letter
    print " "
    letters = ("a".."h").each do |letter|
      print " #{letter}"
    end
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

  def dup
    new_board = Board.new

    self.board.each_with_index do |row,row_i|
      row.each_with_index do |piece,col_i|
        unless piece.nil?
          #p piece.dup
          new_board[[row_i, col_i]] = piece.dup(new_board)
        end
      end
    end

    new_board
  end

end
