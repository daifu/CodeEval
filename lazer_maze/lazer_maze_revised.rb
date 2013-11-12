# It is the factory class to create all different directions
#
module Direction
  class DirectionNotFoundError < Exception; end
  class DirectionRepeatedError < Exception; end

  attr_accessor :cur_dir
  attr_accessor :seen_dirs

  def direction
    {'>' => :go_east,
     '@' => :go_east,
     'v' => :go_south,
     '<' => :go_west,
     '^' => :go_north}
  end

  # Go based on previous direction
  #
  def go_prev_dir
    self.send(@cur_dir)
  end

  def store_seen_dir(dir)
    raise DirectionRepeatedError.new("Direction repeated") if (repeated_dir(dir))
    @seen_dirs[dir_key(dir)] = 1
  end

  def repeated_dir(dir)
    !@seen_dirs[dir_key(dir)].nil?
  end

  def dir_key(dir)
    "#{self.row},#{self.col},#{dir}"
  end

  def go_north
    self.row -= 1 #go up
  end

  def go_east
    self.col += 1 #go right
  end

  def go_south
    self.row += 1 #go down
  end

  def go_west
    self.col -= 1 #go left
  end

  # Go to direction based on dir, love to see how ruby sending message
  # to the object dynamically
  #
  def go dir
    unless direction[dir].nil?
      @seen_dirs = {} unless @seen_dirs

      store_seen_dir(dir)
      @cur_dir = direction[dir]
      self.send(direction[dir])
    else
      raise DirectionNotFoundError.new("Direction not found")
    end
  end

end

# Note: Use duck typing here to include 
class Laser
  include Direction
  attr_accessor :row, :col

  def initialize(args)
    @row = args[:row]
    @col = args[:col]
  end
end

# It is basically a Integer for
# this problem
#
class Steps
  def initialize(number)
    @number = number
  end

  def increment
    @number += 1
  end

  def to_i
    @number.to_i
  end

  def set_finished
    @number = -1
  end
end

# Maze base class
#
class Maze
  attr_accessor :maze

  def initialize
    @maze = []
    @is_finished = false
  end

  # Set maze is finished/solved
  def set_finished
    @is_finished = true
  end
end

# It is a maze specify by this problem
#
class LazerMaze < Maze
  attr_accessor :maze

  def initialize
    super
  end

  # Create the maze form STDIN
  #
  def build_maze
    while(line = gets) do
      @maze << line.strip.split('')
    end
  end

  # Return the start point of the maze
  #
  def start
    @maze.each_with_index do |line, row|
      line.each_with_index do |ele, col|
        return {row: row, col: col} if ele == '@'
      end
    end
  end

  # Check if the maze is finished by the lazer
  #
  # Params:
  # +laser+:: the laser object
  def is_finished(laser)
    return true if laser.col == @maze[0].size ||
                   laser.row == maze.size ||
                   laser.row == -1 ||
                   laser.col == -1 ||
                   @is_finished
    return false
  end

  # Return the dir type at postion
  #
  # Params:
  # +pos+:: the Laser object
  def at(pos)
    @maze[pos.row][pos.col]
  end

  # Mark it walked with nil, so it will cause the exception
  # and terminate the loop
  #
  def mark_it_changed_direction(laser)
    @maze[laser.row][laser.col] = nil
  end
end

# It is a main class the solve the maze! Yay
#
class Solver
  attr_accessor :maze

  def initialize
    @steps = Steps.new(0)
    @maze  = LazerMaze.new
  end

  # Move the lazer to the next postion
  #
  def move
    dir_type = @maze.at(@laser)
    @laser.go(dir_type)
    @steps.increment
  rescue Direction::DirectionNotFoundError
    # Not found the dir, and follow the previous direction
    @laser.go_prev_dir
    @steps.increment
  rescue Direction::DirectionRepeatedError
    # Terminate the loop because we found the infinite loop
    @maze.set_finished
    @steps.set_finished
  end

  # Main logic to solve the maze
  #
  def solve
    @maze.build_maze
    @laser = Laser.new(@maze.start)
    while(!@maze.is_finished(@laser)) do
      move
    end
    @steps.to_i
  end
end

# To run the program
# solver = Solver.new
# solver.solve
