# frozen_string_literal: true

require_relative 'board'

# TODO:
# Filter any moves that put yourself in check
# check for checkmate and stalemate
# introduce castling
# introduce en passant for Pawn
# introduce option to resign

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @cur_player = 'white'
    @player_sel = nil
  end

  def game_loop
    @board.print_board
    puts "CHECK!".magenta if @board.in_check?(@cur_player)
    puts "Player #{@cur_player}, it's your turn".cyan
    init_move
  end

  def save_game
    save_name = $prompt.ask("Choose a name for saved game")
    puts "Game saved".light_cyan
    File.open("./saved_games/#{save_name}.yml", "w") { |f| YAML.dump(self, f) }
    init_move
  end

  def init_move
    column_choice = prompt_column
    return save_game if column_choice == 'i'
    return resign if column_choice == 'j' && $prompt.yes?('Are you sure you wish to resign?')
    return init_move if column_choice == 'j'
    row_choice = $prompt.ask('Pick row (1-8)') { |q| q.in('1-8') }.to_i
    sel_square = @board.find_square(column_choice, row_choice)
    unless sel_square['content'].color == @cur_player
      puts 'Square does not hold one of your pieces, try again'.red
      return init_move
    end
    if sel_square['content'].moves_array.empty?
      puts "Your #{sel_square['content'].class} at #{sel_square['content'].pos.join} "\
        "has no possible moves.\nPick another one".red
      return init_move
    end
    puts "Your #{sel_square['content'].class} at #{sel_square['content'].pos.join} "\
        'has the following possible moves:'
    sel_square['content'].moves_array.sort.each { |move| print "#{move.join} ".magenta }
    puts "\n"
    return init_move unless $prompt.yes?('Continue with this piece? (Press ENTER or "n")', default: "Y")

    choices = sel_square['content'].moves_array.collect(&:join).sort
    new_square_loc = $prompt.select('Choose a move:', choices).split(//)
    new_square = @board.find_square(new_square_loc[0], new_square_loc[1].to_i)
    make_move(sel_square, new_square)
  end

  def prompt_column
    column_choice = $prompt.ask("Pick column (a-h), 'i' to save game or 'j' to resign") do |q|
      q.in('a-j')
    end
  end

  def resign
    winner = @cur_player == 'white' ? 'black' : 'white'
    puts "Player #{@cur_player} resign".red
    puts "Player #{winner} wins!".green
    return if $prompt.no?('Play a new game?', default: "Y")
    return new_game
  end

  def new_game
    puts "New game!"
    new_game = Game.new
    new_game.game_loop
  end

  def make_move(sel_square, new_square)
    duplicate = sel_square['content'].dup
    duplicate.pos = new_square['content'].pos
    new_square['content'] = duplicate
    sel_square['content'] = EmptySpace.new(sel_square['content'].pos)
    promote_pawn(new_square)
    @cur_player = @cur_player == 'white' ? 'black' : 'white'
    game_loop
  end

  def promote_pawn(sq)
    if @cur_player == 'white' && sq['content'].is_a?(Pawn) && sq['row'] == 8
      sq['content'] = Queen.new("#{sq['column']}#{sq['row'].to_s}", 'white')
    end
    if @cur_player == 'black' && sq['content'].is_a?(Pawn) && sq['row'] == 1
      sq['content'] = Queen.new("#{sq['column']}#{sq['row'].to_s}", 'black')
    end
  end
end
