require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @cur_player = 'white'
  end

  def game_loop
    turn_message
  end

  def turn_message
    puts "Player #{@cur_player.upcase}, make your choice"
    puts "Type the position of desired piece to move (eg. 'a1')"
    puts "Or type 'c', 'cm', or 's' to declare check, checkmate or save game"
  end
end


