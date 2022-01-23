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
      ['a', 1, 'rook'],
      ['b', 1, 'knight'],
      ['c', 1, 'bishop'],
      ['d', 1, 'queen'],
      ['e', 1, 'king'],
      ['f', 1, 'bishop'],
      ['g', 1, 'knight'],
      ['h', 1, 'rook'],
      ['a', 8, 'rook'],
      ['b', 8, 'knight'],
      ['c', 8, 'bishop'],
      ['d', 8, 'queen'],
      ['e', 8, 'king'],
      ['f', 8, 'bishop'],
      ['g', 8, 'knight'],
      ['h', 8, 'rook'],
    ]
    [*'a'..'h'].each do |column|
      @init_setup << [column, 2, 'pawn']
      @init_setup << [column, 7, 'pawn']
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
