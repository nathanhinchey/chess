require 'byebug'
require_relative 'board'
require_relative 'computer_player'

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

  attr_reader :board

  def play
    comp = ComputerPlayer.new(self.board, :black)
    color = :white
    loop do
      @board.print_board

      input_loop(color) #color = white
      color = switch_color(color) #color = black
      break if @board.checkmate?(color) #color = black
      from_pos, to_pos = comp.make_move
      @board.move(from_pos, to_pos)
      color = switch_color(color) #color = white
      break if @board.checkmate?(color) #color = white

    end
    @board.print_board
    puts "#{switch_color(color).to_s.capitalize} wins!"
  end

  def switch_color(color)
    color == :white ? :black : :white
    # $black_to_move = true
  end

  def input_loop(color)
    moved = false
    until moved
      puts "#{color.to_s.capitalize}'s turn to move."
      from_pos, to_pos = get_move
      moved = @board.make_legal_move(from_pos, to_pos, color)
    end
  end

  def valid_input?(string)
    if string[0..5] == "array:"
      string = string[6..-1]
      p "array move"
      array_move!(string)
      @board.print_board
      return false
    end
    exit if string == "exit" || string == "quit"
    /[a-h][1-8]:[a-h][1-8]/.match(string)
  end

  def get_move
    puts "Enter a move:"
    move = gets.chomp.downcase
    until valid_input?(move)
      puts "Invalid move."
      puts "Valid moves are of the form <start>:<end> (e.g. B2:B4)."
      puts "Enter a move (or type 'exit' to quit):"
      move = gets.chomp.downcase
    end
    translate_move(move)
  end

  def translate_move(move)
    from_position, to_position = move.split(":")
    from_col = TRANSLATION_HASH[from_position[0]]
    from_row = TRANSLATION_HASH[from_position[1]]
    to_col = TRANSLATION_HASH[to_position[0]]
    to_row = TRANSLATION_HASH[to_position[1]]

    [[from_row,from_col],[to_row,to_col]]
  end

  def array_move!(moves)
    moves_arr = moves.split(",")
    moves_arr.each do |move|
      puts move
      p translate_move(move)
      from_pos, to_pos = translate_move(move)
      @board.move(from_pos, to_pos)
    end
  end

  def print_board
    @board.print_board
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
