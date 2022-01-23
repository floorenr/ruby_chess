class Rook
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265C" : "\u2656"
  end
end

class Knight
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265E" : "\u2658"
  end
end

class Bishop
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265D" : "\u2657"
  end
end

class Queen
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265B" : "\u2655"
  end
end

class King
  attr_accessor :graphic

  def initialize(color = 'black')
    @color = color
    @graphic = @color == 'black' ? "\u265A" : "\u2654"
  end
end

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