# frozen_string_literal:false

require './lib/cell'
# Board class to store all cells
class Board
  attr_reader :cells

  def initialize
    @cells = []
    populate_board
  end

  private

  def populate_board
    x = 0
    y = 0
    until x >= 8
      until y >= 8
        @cells.push(Cell.new([x, y]))
        y += 1
      end
      y = 0
      x += 1
    end
  end
end
