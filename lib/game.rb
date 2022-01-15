# frozen_string_literal: true

class Board
  attr_accessor :board_array

  def initialize
    @board_array = []
    (1..8).each do |i|
      ('a'..'h').each do |j|
        @board_array << { 'column' => j, 'row' => i , 'content' => nil }
      end
    end
    init_pawns
  end

  def init_pawns
    @board_array.collect! do |pos|
      if pos['row'] == 2 || pos['row'] == 7
        pos['content'] = 'pawn'
        pos
      else
        pos
      end
    end
  end
end
