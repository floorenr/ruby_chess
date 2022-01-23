# frozen_string_literal: true

class Board
  attr_accessor :board_array

  def initialize
    @board_array = []
    (1..8).each do |i|
      ('a'..'h').each do |j|
        @board_array << { 'column' => j, 'row' => i, 'content' => nil }
      end
    end
    init_board
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
      ['h', 8, Rook.new],
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

class Rook
  def initialize(color = 'black')
    @color = color
  end
end

class Knight
  def initialize(color = 'black')
    @color = color
  end
end

class Bishop
  def initialize(color = 'black')
    @color = color
  end
end

class Queen
  def initialize(color = 'black')
    @color = color
  end
end

class King
  def initialize(color = 'black')
    @color = color
  end
end

class Pawn
  def initialize(color = 'black')
    @color = color
  end
end

