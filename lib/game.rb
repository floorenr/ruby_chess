require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @cur_player = 'white'
    @prompt = TTY::Prompt.new
  end

  def game_loop
    turn_message
  end

  def turn_message
    choices = ["Make a move", "Call 'check'", "Call 'checkmate'", "Save game"]
    selection = @prompt.select("Player #{@cur_player.upcase}, make your choice", choices)
  end
end


