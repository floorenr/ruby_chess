# frozen_string_literal: true

class Board
  attr_accessor :board_array

  def initialize
    @board_array = []
    (1..8).each do |i|
      temp_array = []
      ('a'..'h').each do |j|
        temp_array << { 'pos' => "#{j},#{i}" }
      end
      @board_array << temp_array
    end
  end
end
