# frozen_string_literal: true

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
    save_game if @player_sel == 'Save game'
    init_move if @player_sel == 'Make a move'
  end

  def turn_message
    choices = ['Make a move', 'Save game']
    @player_sel = @prompt.select("Player #{@cur_player.upcase}, make your choice", choices)
  end

  def save_game
    # serialize itself
    # save to new file
    # return to game_loop
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
    sel_square['content'].moves_array.each { |move| print "#{move.join} " }
    puts "\n"
    return init_move unless @prompt.yes?('Continue with this piece?')

    choices = sel_square['content'].moves_array.collect(&:join)
    new_square_loc = @prompt.select('Choose a move:', choices).split(//)
    new_square = @board.find_square(new_square_loc[0], new_square_loc[1].to_i)
    make_move(sel_square, new_square)
  end

  def make_move(sel_square, new_square)
    new_square['content'] = sel_square['content'].dup
    sel_square['content'] = EmptySpace.new
    # run game_loop again for other user
  end
end
