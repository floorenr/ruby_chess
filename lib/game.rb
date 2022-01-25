require_relative 'board'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @cur_player = 'white'
    @prompt = TTY::Prompt.new
    @player_sel = nil
  end

  def game_loop
    @board.print_board
    turn_message
    save_game if @player_sel == "Save game"
    init_move if @player_sel == "Make a move"
  end

  def turn_message
    choices = ["Make a move", "Save game"]
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
    sel_square = @board.find_square(column_choice, row_choice)
    unless sel_square['content'].color == @cur_player
      puts "Square does not hold one of your pieces, try again"
      return init_move
    end
    # ask for desired move
    # check validity of move
    make_move
  end

  def make_move
    #make the move
  end
end


