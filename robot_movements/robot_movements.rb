class RobotMovements

  Robot = Struct.new(:x, :y, :path, :max_x, :max_y) do
    def destination?
      return x == 0 && y == 0
    end

    def up?
      y - 1 >= 0 && !path.include?("#{x},#{y-1}")
    end

    def left?
      x - 1 >= 0 && !path.include?("#{x-1},#{y}")
    end

    def right?
      x + 1 <= max_x && !path.include?("#{x+1},#{y}")
    end

    def down?
      y + 1 <= max_y && !path.include?("#{x},#{y+1}")
    end
  end

  def initialize(dimension=4)
    @dim = dimension
  end

  def next_step(robot)
    queue = []
    queue << Robot.new(robot.x, robot.y-1, robot.path + ["#{robot.x},#{robot.y-1}"], robot.max_x, robot.max_y) if robot.up?
    queue << Robot.new(robot.x, robot.y+1, robot.path + ["#{robot.x},#{robot.y+1}"], robot.max_x, robot.max_y) if robot.down?
    queue << Robot.new(robot.x-1, robot.y, robot.path + ["#{robot.x-1},#{robot.y}"], robot.max_x, robot.max_y) if robot.left?
    queue << Robot.new(robot.x+1, robot.y, robot.path + ["#{robot.x+1},#{robot.y}"], robot.max_x, robot.max_y) if robot.right?
    queue
  end

  def rec_get_num_of_ways(robot)
    if robot.destination?
      @robots << robot.path unless @robots.include?(robot.path)
      return
    end
    next_step(robot).each do |next_robot|
      rec_get_num_of_ways(next_robot)
    end
    return
  end

  def num_of_ways
    robot  = Robot.new(@dim-1, @dim-1, ["#{@dim-1},#{@dim-1}"], @dim-1, @dim-1)
    @robots = []
    rec_get_num_of_ways(robot)
    @robots.size
  end

end
