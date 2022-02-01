# frozen_string_literal: true

require_relative 'board'

# TODO:
# Filter any moves that put yourself in check
# check for check and checkmate and stalemate
# promote Pawn to Queen when reaching end of board
# introduce castling
# introduce en passant for Pawn
# introduce option to resign

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
    save_game if @player_sel == 'Save game'
    init_move if @player_sel == 'Make a move'
  end

  def turn_message
    choices = ['Make a move', 'Save game']
    @player_sel = @prompt.select("Player #{@cur_player.upcase}, make your choice", choices)
  end

  def save_game
    save_name = @prompt.ask("Choose a name for saved game")
    puts "Game saved".light_cyan
    File.open("./saved_games/#{save_name}.yml", "w") { |f| YAML.dump(self, f) }
    init_move
  end

  def init_move
    column_choice = @prompt.ask('Pick column (a-h)') { |q| q.in('a-h') }
    row_choice = @prompt.ask('Pick row (1-8)') { |q| q.in('1-8') }.to_i
    sel_square = @board.find_square(column_choice, row_choice)
    unless sel_square['content'].color == @cur_player
      puts 'Square does not hold one of your pieces, try again'
      return init_move
    end
    if sel_square['content'].moves_array.empty?
      puts "Your #{sel_square['content'].class} at #{sel_square['content'].pos.join} "\
        "has no possible moves.\nPick another one"
      return init_move
    end
    puts "Your #{sel_square['content'].class} at #{sel_square['content'].pos.join} "\
        'has the following possible moves:'
    sel_square['content'].moves_array.sort.each { |move| print "#{move.join} " }
    puts "\n"
    return init_move unless @prompt.yes?('Continue with this piece? (Press ENTER or "n")', default: "Y")

    choices = sel_square['content'].moves_array.collect(&:join).sort
    new_square_loc = @prompt.select('Choose a move:', choices).split(//)
    new_square = @board.find_square(new_square_loc[0], new_square_loc[1].to_i)
    make_move(sel_square, new_square)
  end

  def make_move(sel_square, new_square)
    duplicate = sel_square['content'].dup
    duplicate.pos = new_square['content'].pos
    new_square['content'] = duplicate
    sel_square['content'] = EmptySpace.new(sel_square['content'].pos)
    @cur_player = @cur_player == 'white' ? 'black' : 'white'
    game_loop
  end
end
