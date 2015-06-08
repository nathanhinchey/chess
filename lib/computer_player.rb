require_relative 'board'

class ComputerPlayer
  def initialize(board, color)
    @board = board
    @color = color
    @moved_pieces = []
  end

  def make_move
    skipped_move = nil
    skipped_piece = nil
    best_move = nil
    best_piece = nil
    best_capture = 0
    @board.each_piece do |piece|
      if piece.color == @color
        piece.valid_moves.each do |move|
          if @board[move] && @board[move].value > best_capture
            best_move = [piece.position, move]
            best_piece = piece
            best_capture = @board[move].value
          elsif skipped_move.nil? || !@moved_pieces.include?(piece)
            skipped_move = [piece.position, move]
          end
        end
      end
    end
    if best_move
      @moved_pieces << best_piece
      best_move
    else
      @moved_pieces << skipped_piece
      skipped_move
    end
  end
end


<<-CHESS
array:e8:h6,a1:a8,b1:b8,c1:c8,d1:d8,e1:e8,f1:f8,g1:g8,h1:h8
CHESS
