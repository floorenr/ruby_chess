class Rook
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265C" : "\u2656"
    @pos = pos
  end
end

class Knight
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265E" : "\u2658"
    @pos = pos
  end
end

class Bishop
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265D" : "\u2657"
    @pos = pos
  end
end

class Queen
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265B" : "\u2655"
    @pos = pos
  end
end

class King
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265A" : "\u2654"
    @pos = pos
  end
end

class Pawn
  attr_accessor :graphic, :color, :pos

  def initialize(pos, color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265F" : "\u2659"
    @pos = pos
  end
end

class EmptySpace
  attr_accessor :graphic

  def initialize
    @graphic = ' '
  end
end