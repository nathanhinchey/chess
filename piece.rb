class Piece
  attr_reader :color, :board
  def initialize(board, color, position)
    @color = color
    @board = board
    @position = position
  end

  def move
  end

  def valid_move?(position_to)
    if ((position_to[0].between?(0 , 7) && position_to[1].between?(0 , 7)) && (board[position_to].nil? || board[position_to].color != self.color ))
      return true
    end

    false
  end
end

class SlidingPiece < Piece
  def initialize(board, diagonal = false, horizontal_and_vertical = false)
    @diagonal = diagonal
    @horizontal_and_vertical = horizontal_and_vertical
    super(board, "black", [0,0])
  end

  def move(to_position)
    #if horiz_or_vert?(to_position) == @horizontal_and_vertical ||
    #  horiz_or_vert?(to_position) == diagonal

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

  # def legal_horiz_move(to_position)
  #   return false unless to_position[1] == @position[1]
  #   if to_position[0] > @position[0]
  #     high_x_pos, low_x_pos = to_position[0], @position[0]
  #   else
  #     low_x_pos, high_x_pos = to_position[0], @position[0]
  #   end
  #   (low_x_pos..high_x_pos).each do |step|
  #     next if valid_move?([@position[0] + step, @position[1]])
  #     return false
  #   end
  #
  #   true
  # end

  # def legal_vert_move(to_position)
  #   return false unless to_position[0] == @position[0]
  #   if to_position[1] > @position[1]
  #     high_y_pos, low_y_pos = to_position[1], @position[1]
  #   else
  #     low_y_pos, high_y_pos = to_position[1], @position[1]
  #   end
  #   (low_y_pos..high_y_pos).each do |step|
  #     next if valid_move?([@position[0], @position[1] + step])
  #     return false
  #   end
  #
  #   true
  # end



  def legal_path?(to_position)
    # return false unless to_position[0] == @position[0]
    # TODO make sure it's a legal direction
    x_positions = [to_position[0], @position[0]]
    y_positions = [to_position[1], @position[1]]

    low_x_pos, high_x_pos = x_positions.sort
    low_y_pos, high_y_pos = y_positions.sort


    (low_y_pos..high_y_pos).each do |step|
      next if valid_move?([@position[0] + step, @position[1] + step])
      return false
    end

    true
  end


end
# [[piece object][nil][nil][piece_object]]


class Board
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
