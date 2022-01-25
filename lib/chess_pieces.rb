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
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265C" : "\u2656"
    @pos = pos.split(//)
    @moves_array = []
  end

  def calc_moves
    directions = [[0, 1], [1, 0], [-1, 0], [0, -1]
    directions.each do |direction|
      temp_pos = @pos
      loop do
        temp_pos[0] = (temp_pos[0].ord + direction[0]).chr
        temp_pos[1] = (temp_pos[1].to_i + direction[1]).to_s
        p temp_pos
        break if $game.board.sq_occ_by?(temp_pos[0], temp_pos[1].to_i, @color)
        break if offboard?(temp_pos)
        @moves_array << temp_pos
        break if $game.board.sq_occ_by_opp?(temp_pos[0], temp_pos[1].to_i)
      end
    end
    p @moves_array
  end
end

class Knight
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265E" : "\u2658"
    @pos = pos.split(//)
  end

  def calc_moves
    # @moves_array =
  end
end

class Bishop
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265D" : "\u2657"
    @pos = pos.split(//)
  end

  def calc_moves
    # @moves_array =
  end
end

class Queen
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265B" : "\u2655"
    @pos = pos.split(//)
  end

  def calc_moves
    # @moves_array =
  end
end

class King
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265A" : "\u2654"
    @pos = pos.split(//)
  end

  def calc_moves
    # @moves_array =
  end
end

class Pawn
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265F" : "\u2659"
    @pos = pos.split(//)
  end

  def calc_moves
    # @moves_array =
  end
end

class EmptySpace
  attr_accessor :graphic, :color

  def initialize
    @graphic = ' '
    @color = nil
  end

  def calc_moves

  end
end