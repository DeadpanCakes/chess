require './lib/board'
require './lib/cell'
require './lib/knight'

k = Knight.new [5, 5]
k.move_to_cell([], [], [1, 2])
