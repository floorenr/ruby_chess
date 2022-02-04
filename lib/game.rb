# frozen_string_literal: true

require_relative 'board'

# TODO:
# Filter any moves that put yourself in check
# check for checkmate and stalemate
# introduce castling
# introduce en passant for Pawn

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @cur_player = 'white'
    @player_sel = nil
  end

  def game_loop
    @board.calc_all_moves
    @board.print_board
    puts 'CHECK!'.magenta if @board.in_check?(@cur_player)
    puts "Player #{@cur_player}, it's your turn".cyan
    init_move
    game_loop
  end

  def save_game
    save_name = $prompt.ask('Choose a name for saved game')
    puts 'Game saved'.light_cyan
    File.open("./saved_games/#{save_name}.yml", 'w') { |f| YAML.dump(self, f) }
    init_move
  end

  def init_move
    column_choice = prompt_column
    return save_game if column_choice == 'i'
    return resign if column_choice == 'j' && $prompt.yes?('Are you sure you wish to resign?')
    return init_move if column_choice == 'j'

    row_choice = $prompt.ask('Pick row (1-8)') { |q| q.in('1-8') }.to_i
    sel_square = @board.find_square(column_choice, row_choice)
    return init_move if check_sel_square(sel_square) == 'run again'

    choices = sel_square['content'].moves_array.collect(&:join).sort
    new_square_loc = $prompt.select('Choose a move:', choices).split(//)
    new_square = @board.find_square(new_square_loc[0], new_square_loc[1].to_i)
    @board.make_move(sel_square, new_square, @cur_player)
    @cur_player = @cur_player == 'white' ? 'black' : 'white'
  end

  def check_sel_square(sel_square)
    unless sel_square['content'].color == @cur_player
      puts 'Square does not hold one of your pieces, try again'.red
      return 'run again'
    end
    if sel_square['content'].moves_array.empty?
      puts "Your #{sel_square['content'].class} at #{sel_square['content'].pos.join} "\
        "has no possible moves.\nPick another one".red
      return 'run again'
    end
    puts "Your #{sel_square['content'].class} at #{sel_square['content'].pos.join} "\
        'has the following possible moves:'
    sel_square['content'].moves_array.sort.each { |move| print "#{move.join} ".magenta }
    puts "\n"
    return 'run again' unless $prompt.yes?('Continue with this piece? (Press ENTER or "n")', default: 'Y')
  end

  def prompt_column
    $prompt.ask("Pick column (a-h), 'i' to save game or 'j' to resign") do |q|
      q.in('a-j')
    end
  end

  def resign
    winner = @cur_player == 'white' ? 'black' : 'white'
    puts "Player #{@cur_player} resign".red
    puts "Player #{winner} wins!".green
    return if $prompt.no?('Play a new game?', default: 'Y')

    new_game
  end

  def new_game
    puts 'New game!'
    new_game = Game.new
    new_game.game_loop
  end
end
