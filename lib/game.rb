require_relative 'board'

class Game
  def initialize
    @board = Board.new
    @cur_player = 'white'
    @prompt = TTY::Prompt.new
    @player_sel = nil
  end

  def game_loop
    turn_message
    save_game if @player_sel == "Save game"
    call_check if @player_sel == "Call 'check'"
    call_checkmate if @player_sel == "Call 'checkmate'"
    make_move if @player_sel == "Make a move"
  end

  def turn_message
    choices = ["Make a move", "Call 'check'", "Call 'checkmate'", "Save game"]
    @player_sel = @prompt.select("Player #{@cur_player.upcase}, make your choice", choices)

  end

  def save_game

  end

  def make_move
    column_choice  = @prompt.ask("Pick column (a-h)") { |q| q.in("a-h") }
    row_choice  = @prompt.ask("Pick row (1-8)") { |q| q.in("1-8") }.to_i
  end

  def call_check

  end

  def call_checkmate

  end
end


