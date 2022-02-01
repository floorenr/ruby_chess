# frozen_string_literal: true

module ChessPiece
  def offboard?(pos)
    if [*1..8].include?(pos[1].to_i) && [*'a'..'h'].include?(pos[0])
      false
    else
      true
    end
  end
end

class Rook
  include ChessPiece
  attr_accessor :graphic, :color, :pos, :moves_array

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265C" : "\u2656"
    @pos = pos.split(//)
    @moves_array = []
  end

  def calc_moves(current_board)
    @moves_array = []
    directions = [[0, 1], [1, 0], [-1, 0], [0, -1]]
    directions.each do |direction|
      temp_pos = @pos.dup
      loop do
        temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
        temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
        break if offboard?(temp_pos)
        break if current_board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)

        @moves_array << temp_pos.dup
        break if current_board.sq_occ_by_opp?(temp_pos[0], temp_pos[1].to_i, @color)
      end
    end
  end
end

class Knight
  include ChessPiece
  attr_accessor :graphic, :color, :pos, :moves_array

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265E" : "\u2658"
    @pos = pos.split(//)
    @moves_array = []
  end

  def calc_moves(current_board)
    @moves_array = []
    directions = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    directions.each do |direction|
      temp_pos = @pos.dup
      temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
      temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
      next if offboard?(temp_pos) || current_board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)

      @moves_array << temp_pos.dup
    end
  end
end

class Bishop
  include ChessPiece
  attr_accessor :graphic, :color, :pos, :moves_array

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265D" : "\u2657"
    @pos = pos.split(//)
    @moves_array = []
  end

  def calc_moves(current_board)
    @moves_array = []
    directions = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
    directions.each do |direction|
      temp_pos = @pos.dup
      loop do
        temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
        temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
        break if offboard?(temp_pos)
        break if current_board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)

        @moves_array << temp_pos.dup
        break if current_board.sq_occ_by_opp?(temp_pos[0], temp_pos[1].to_i, @color)
      end
    end
  end
end

class Queen
  include ChessPiece
  attr_accessor :graphic, :color, :pos, :moves_array

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265B" : "\u2655"
    @pos = pos.split(//)
    @moves_array = []
  end

  def calc_moves(current_board)
    @moves_array = []
    directions = [[1, 1], [1, -1], [-1, -1], [-1, 1], [0, 1], [1, 0], [-1, 0], [0, -1]]
    directions.each do |direction|
      temp_pos = @pos.dup
      loop do
        temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
        temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
        break if offboard?(temp_pos)
        break if current_board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)

        @moves_array << temp_pos.dup
        break if current_board.sq_occ_by_opp?(temp_pos[0], temp_pos[1].to_i, @color)
      end
    end
  end
end

class King
  include ChessPiece
  attr_accessor :graphic, :color, :pos, :moves_array

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265A" : "\u2654"
    @pos = pos.split(//)
    @moves_array = []
  end

  def calc_moves(current_board)
    @moves_array = []
    directions = [[1, 1], [1, -1], [-1, -1], [-1, 1], [0, 1], [1, 0], [-1, 0], [0, -1]]
    directions.each do |direction|
      temp_pos = @pos.dup
      temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
      temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
      next if offboard?(temp_pos) || current_board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)

      @moves_array << temp_pos.dup
    end
  end
end

class Pawn
  include ChessPiece
  attr_accessor :graphic, :color, :pos, :moves_array, :capture_moves_array

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265F" : "\u2659"
    @pos = pos.split(//)
    @moves_array = []
    @capture_moves_array = []
  end

  def calc_moves(current_board)
    @moves_array = []
    @capture_moves_array = []
    capture_directions = determine_capture_directions
    directions = determine_directions
    capture_directions.each do |direction|
      temp_pos = @pos.dup
      temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
      temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
      next if offboard?(temp_pos)

      @moves_array << temp_pos.dup if current_board.sq_occ_by_opp?(temp_pos[0], temp_pos[1].to_i, @color)
    end
    @capture_moves_array = @moves_array.dup
    directions.each do |direction|
      temp_pos = @pos.dup
      temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
      next if offboard?(temp_pos) || current_board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)
      next if current_board.sq_occ_by_opp?(temp_pos[0], temp_pos[1].to_i, @color)

      @moves_array << temp_pos.dup
    end
  end

  def determine_directions
    if @color == 'white'
      if @pos[1] == '2'
        [[0, 1], [0, 2]]
      else
        [[0, 1]]
      end
    elsif @pos[1] == '7'
      [[0, -1], [0, -2]]
    else
      [[0, -1]]
    end
  end

  def determine_capture_directions
    @color == 'white' ? [[-1, 1], [1, 1]] : [[1, -1], [-1, -1]]
  end
end

class EmptySpace
  attr_accessor :graphic, :color, :pos

  def initialize(pos)
    @graphic = ' '
    @color = nil
    @pos = pos
  end

  def calc_moves(current_board); end
end
