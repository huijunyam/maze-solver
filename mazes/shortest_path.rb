require_relative 'node'

class Maze
  attr_reader :maze, :close_list, :open_list, :current_node, :start_node, :end_node,
              :path

  def initialize(maze)
    @open_list = []
    @close_list = []
    @path = []
    @maze = maze
  end

  def run
    start_end_coordinate
    @current_node = start_node

    until current_node.pos == end_node.pos
      close_list << current_node.pos
      adjacent_nodes(current_node)
      @current_node = f_score(current_node, open_list)
      open_list.delete(current_node)
    end

    shortest_path = find_path(current_node)
    display(shortest_path)
  end

  private
  def start_end_coordinate
    maze.each_with_index do |line, row|
      line.each_with_index do |char, col|
        if char == "S"
          @start_node = Node.new([row, col])
        elsif char == "E"
          @end_node = Node.new([row, col])
        end
      end
    end
  end

  def adjacent_nodes(node)
     x, y = node.pos
     ((x-1)..(x+1)).each do |row|
       ((y-1)..(y+1)).each do |col|
         next if close_list.include?([row, col])
         open_list << Node.new([row, col], node) if maze[row][col] != "*"
       end
     end
   end

   def f_score(previous, list)
     score = list.map.with_index do |node|
       node.g_score(previous) + node.h_score(end_node)
     end
     list[score.index(score.min)]
   end

  def display(path_line)
    maze.map.with_index do |line, row|
      line.map.with_index do |char, col|
        path_line.include?([row, col]) ? "X" : char
      end
    end.each { |line| puts line.join("") }
  end

  def find_path(node)
    if node.parent != start_node
      path << node.parent.pos
      find_path(node.parent)
    else
      path
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  filename = File.readlines("maze1.txt").map { |line| line.chomp.chars }
  Maze.new(filename).run
end
