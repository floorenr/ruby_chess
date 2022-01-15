# frozen_string_literal: true

class Board
  attr_accessor :board_array

  def initialize
    @board_array = []
    (1..8).each do |i|
      ('a'..'h').each do |j|
        @board_array << { 'column' => j 'row' => i , 'content' => nil }
      end
    end
    # init_pieces
  end

  # def init_pieces
  #   @board_array.collect! { |element|
  #     (element[] == "hello") ? "hi" : element
  #   }
  #   puts x
  end
end
