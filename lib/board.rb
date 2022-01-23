# frozen_string_literal: true

# Instance of a chess board
class Board
  attr_accessor :board_array

  def initialize
    @board_array = []
    (1..8).each do |i|
      ('a'..'h').each do |j|
        @board_array << { 'column' => j, 'row' => i, 'content' => EmptySpace.new }
      end
    end
    init_board
    print_board
  end

  def print_board
    rows = @board_array.each_slice(8).to_a
    puts "\u250c" + ("\u2500"*3 + "\u252c")*7 + "\u2500"*3 + "\u2510"
    rows.reverse.each do |row|
      print = row.map { |f| " #{f['content'].graphic} " }.join("\u2502")
      puts "\u2502" + print + "\u2502"
      puts "\u251c" + ("\u2500"*3 + "\u253c")*7 + "\u2500"*3 + "\u2524" unless row[0]['row'] == 1
    end
    puts "\u2514" + ("\u2500"*3 + "\u2534")*7 + "\u2500"*3 + "\u2518"
  end

  def init_board
    create_setup
    @init_setup.each do |piece|
      init_piece(piece[0], piece[1], piece[2])
    end
  end

  def create_setup
    @init_setup = [
      ['a', 1, Rook.new('white')],
      ['b', 1, Knight.new('white')],
      ['c', 1, Bishop.new('white')],
      ['d', 1, Queen.new('white')],
      ['e', 1, King.new('white')],
      ['f', 1, Bishop.new('white')],
      ['g', 1, Knight.new('white')],
      ['h', 1, Rook.new('white')],
      ['a', 8, Rook.new],
      ['b', 8, Knight.new],
      ['c', 8, Bishop.new],
      ['d', 8, Queen.new],
      ['e', 8, King.new],
      ['f', 8, Bishop.new],
      ['g', 8, Knight.new],
      ['h', 8, Rook.new]
    ]
    [*'a'..'h'].each do |column|
      @init_setup << [column, 2, Pawn.new('white')]
      @init_setup << [column, 7, Pawn.new]
    end
  end

  def move_piece; end

  def delete_piece; end

  def init_piece(column, row, content)
    @board_array.collect! do |pos|
      pos['content'] = content if pos['row'] == row && pos['column'] == column
      pos
    end
  end
end

# Instance of a chess piece
class Rook
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265C" : "\u2656"
  end
end

# Instance of a chess piece
class Knight
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265E" : "\u2658"
  end
end

# Instance of a chess piece
class Bishop
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265D" : "\u2657"
  end
end

# Instance of a chess piece
class Queen
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265B" : "\u2655"
  end
end

# Instance of a chess piece
class King
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265A" : "\u2654"
  end
end

# Instance of a chess piece
class Pawn
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265F" : "\u2659"
  end
end

class EmptySpace
  attr_accessor :graphic

  def initialize
    @graphic = ' '
  end
end
