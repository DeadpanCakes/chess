# frozen_string_literal:false

require './lib/board'

# Knight class to store position on board and traverse
class Knight
  attr_reader :coords

  def initialize(coords)
    @coords = coords
    @board = Board.new
  end

  private

  def x
    @coords.first
  end

  def y
    @coords.last
  end

  def gen_graph
    @board.cells.map do |cell|
      {
        coords: cell.coords,
        connections: valid_moves(cell)
      }
    end
  end

  def find_route(route, weighted_graph)
    return route if route.last[:weight] == 1

    connected_cells = weighted_graph.select do |cell|
      cell[:connections].include?(route.last[:coords])
    end
    connected_cells.sort { |a, b| a[:weight] - b[:weight] }
    route.push connected_cells.first
    find_route(route, weighted_graph)
  end

  public

  def valid_moves(cell)
    moves = [[cell.x + 2, cell.y + 1], [cell.x + 1, cell.x + 2], [cell.x - 2, cell.y + 1], [cell.x - 1, cell.y + 2],
             [cell.x + 1, cell.y - 2], [cell.x + 2, cell.y - 1], [cell.x - 2, cell.y - 1], [cell.x - 1, cell.y - 2]]
    out_of_bounds = ->(coord) { coord.negative? || coord >= 8 }
    moves.filter { |coord| coord.none?(&out_of_bounds) }
  end

  def move_to_cell(start, target)
    move_graph = gen_graph
    root = move_graph.find { |cell| cell[:coords] == start }
    history = []
    queue = [{ **root, weight: 1 }]
    until queue.empty?
      curr = queue.shift
      history.push(curr)
      valid_connections = curr[:connections].filter do |c|
        (queue + history).none? { |prev_move| prev_move[:coords] == c }
      end
      moves = move_graph.select do |move|
        valid_connections.any? { |c| c == move[:coords] }
      end
      queue += moves.map { |move| { **move, weight: curr[:weight] + 1 } }
    end
    shortest_path = history.select do |move|
                      move[:connections].include?(target)
                    end.sort { |a, b| a[:weight] - b[:weight] }
    route = find_route([shortest_path.first], history).sort do |a, b|
              a[:weight] - b[:weight]
            end.map { |cell| cell[:coords] }
    route.push(target)
    route
  end
end
