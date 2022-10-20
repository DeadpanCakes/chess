# Cell class to store position on board
class Cell
  attr_reader :coords

  def initialize(coords)
    @coords = coords
  end

  def x
    @coords.first
  end

  def y
    @coords.last
  end
end
