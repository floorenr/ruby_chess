require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @cur_player = 'white'
    @prompt = TTY::Prompt.new
    @selection = nil
  end

  def game_loop
    turn_message
    save_game if @selection == "Save game"
    check if @selection == "Call 'check'"
    checkmate if @selection == "Call 'checkmate'"
    make_move if @selection == "Make a move"
  end

  def turn_message
    choices = ["Make a move", "Call 'check'", "Call 'checkmate'", "Save game"]
    @selection = @prompt.select("Player #{@cur_player.upcase}, make your choice", choices)

  end

  def save_game

  end

  def make_move

  end

  def check

  end

  def checkmate
    
  end
end


