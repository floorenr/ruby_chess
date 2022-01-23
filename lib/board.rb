# frozen_string_literal: true
require_relative 'init_setup'

class Board
  attr_accessor :board_array

  def initialize
    @board_array = []
    (1..8).each do |i|
      ('a'..'h').each do |j|
        @board_array << { 'column' => j, 'row' => i , 'content' => nil }
      end
    end
    init_board
    p @board_array
  end

  def init_board
    Init_setup::PIECES.each do |piece|
      init_piece(piece[0], piece[1], piece[2])
    end
  end

  def move_piece

  end

  def delete_piece

  end

  def init_piece(column, row, content)
    @board_array.collect! do |pos|
      if pos['row'] == row && pos['column'] == column
        pos['content'] = content
        pos
      else
        pos
      end
    end
  end
end