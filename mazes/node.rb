class Node
  attr_reader :pos, :parent

  def initialize(pos, parent = nil)
    @pos = pos
    @parent = parent
  end

  def g_score(previous_node)
    diff = pos.map.with_index do |coordinate, idx|
      (coordinate - previous_node.pos[idx]).abs
    end

    diff == [1, 1] ? 14 : 10
  end

  def h_score(last_node)
    total = pos.map.with_index do |coordinate, idx|
      (coordinate - last_node.pos[idx]).abs
    end.reduce(:+)

    total * 10
  end
end
