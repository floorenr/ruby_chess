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
    init_move if @player_sel == "Make a move"
  end

  def turn_message
    choices = ["Make a move", "Call 'check'", "Call 'checkmate'", "Save game"]
    @player_sel = @prompt.select("Player #{@cur_player.upcase}, make your choice", choices)
  end

  def save_game
    # serialize itself
    # save to new file
    # return to game_loop
  end

  def init_move
    column_choice  = @prompt.ask("Pick column (a-h)") { |q| q.in("a-h") }
    row_choice  = @prompt.ask("Pick row (1-8)") { |q| q.in("1-8") }.to_i
    sel_square = find_square(column_choice, row_choice)
    unless sel_square['content'].color == @cur_player
      puts "Square does not hold one of your pieces. Try again"
      init_move
    end
    # ask for desired move
    # check validity of move
    make_move
  end

  def find_square(column, row)
    return @board.board_array.select { |sq| (sq['column'] == column && sq['row'] == row) }[0]
  end

  def make_move

  end

  def call_check

  end

  def call_checkmate

  end
end


