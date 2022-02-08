# frozen_string_literal: true

require_relative 'board'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @cur_player = 'white'
    @player_sel = nil
    @quit_game = false
  end

  def init_game
    @game_type = $prompt.select('Choose game type?', ['Player vs Player', 'Player vs Computer'])
    if @game_type == 'Player vs Computer'
      @computer_player = %w[white black].sample
      puts "Computer player is #{@computer_player}".cyan
    end
    puts '(black is colored magenta for readability)'
    game_loop
  end

  def game_loop
    @board.calc_all_moves(@cur_player)
    @board.print_board
    checkmate if @board.checkmate?(@cur_player)
    stalemate if @board.stalemate?(@cur_player)
    return if @quit_game == true

    puts 'CHECK!'.magenta if @board.in_check?(@cur_player)
    puts "Player #{@cur_player}, it's your turn".cyan
    @game_type == 'Player vs Computer' && @cur_player == @computer_player ? computer_move : player_move

    return if @quit_game == true

    game_loop
  end

  def save_game
    save_name = $prompt.ask('Choose a name for saved game')
    puts 'Game saved'.light_cyan
    File.open("./saved_games/#{save_name}.yml", 'w') { |f| YAML.dump(self, f) }
    player_move
  end

  def computer_move
    random_movable_sq = @board.board_array.select do |sq|
      sq['content'].color == @cur_player && !sq['content'].moves_array.empty?
    end
                              .sample
    move = random_movable_sq['content'].moves_array.sample
    puts "Computer moves #{random_movable_sq['content'].class} from " \
      "#{random_movable_sq['content'].pos.join} to #{move.join}"
    new_square = @board.find_square(move[0], move[1].to_i)
    reset_enpassant
    @board.make_move(random_movable_sq, new_square, @cur_player)
    @cur_player = opponent
  end

  def player_move
    column_choice = prompt_column
    return save_game if column_choice == 'i'
    return resign if column_choice == 'j' && $prompt.yes?('Are you sure you wish to resign?')
    return player_move if column_choice == 'j'

    row_choice = $prompt.ask('Pick row (1-8)') { |q| q.in('1-8') }.to_i
    sel_square = @board.find_square(column_choice, row_choice)
    return player_move if check_sel_square(sel_square) == 'run again'

    choices = sel_square['content'].moves_array.collect(&:join).sort
    new_square_loc = $prompt.select('Choose a move:', choices).split(//)
    new_square = @board.find_square(new_square_loc[0], new_square_loc[1].to_i)
    reset_enpassant
    case new_square_loc.length
    when 2
      @board.make_move(sel_square, new_square, @cur_player)
    when 3 # only en passant moves have three items in array
      @board.make_enpassant_move(sel_square, new_square, @cur_player)
    end
    @cur_player = opponent
  end

  def reset_enpassant
    @board.enpassant_captured_pos = nil
    @board.enpassant_capturing_pos = nil
    @board.enpassant_move = nil
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
    puts "Player #{@cur_player} resign".red
    puts "Player #{opponent} wins!".green
    @quit_game = true
    return if $prompt.no?('Play a new game?', default: 'Y')

    new_game
  end

  def opponent
    @cur_player == 'white' ? 'black' : 'white'
  end


  def checkmate
    puts "Player #{@cur_player} is checkmate".red
    puts "Player #{opponent} wins!".green
    @quit_game = true
    return if $prompt.no?('Play a new game?', default: 'Y')

    new_game
  end

  def stalemate
    puts "Player #{@cur_player} is stalemate".red
    puts "It's a draw!".green
    @quit_game = true
    return if $prompt.no?('Play a new game?', default: 'Y')

    new_game
  end

  def new_game
    puts 'New game!'
    new_game = Game.new
    new_game.init_game
  end
end
