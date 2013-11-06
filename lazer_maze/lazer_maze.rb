class LazerMaze
  # the object reprent the current state walking
  # in the maze
  Pos    = Struct.new(:row, :col, :steps, :dir)

  # a indicator shows the object walked through the
  # prisms
  WALKED = 'W'

  # Direction of the object can move
  DIRS   = ['>','v','<','^', WALKED]

  # Retrieve the start position
  # Params:
  # +maze+:: the maze
  # the Pos is returned
  def get_start_pos(maze)
    maze.each_with_index do |line, row|
      line.each_with_index do |ele, col|
        return Pos.new(row,col,0,'>') if ele == '@'
      end
    end
  end

  # Check if it reached the wall
  # Params:
  # +pos+: the Pos object
  # +maze+: the maze array
  # ture if it reached the wall or false
  def is_reach_wall(pos, maze)
    return true if pos.col == maze[0].size ||
      pos.row == maze.size ||
      pos.row == -1 ||
      pos.col == -1
    return false
  end

  # Return the next step of the Pos should go
  # Params:
  # +pos+: the Pos object
  # +maze+: the maze array
  # return Pos object if it has step to go, and
  # the Pos with -1 shows the infinite loop
  def move(pos, maze)
    dir = pos.dir
    if DIRS.include?(maze[pos.row][pos.col])
      dir = maze[pos.row][pos.col]
      # Replace prisms with WALKED to indicate
      # it has been walked
      maze[pos.row][pos.col] = WALKED
    end
    return case dir
    when '>'; Pos.new(pos.row, pos.col+1, pos.steps+1, '>')
    when 'v'; Pos.new(pos.row+1, pos.col, pos.steps+1, 'v')
    when '<'; Pos.new(pos.row, pos.col-1, pos.steps+1, '<')
    when '^'; Pos.new(pos.row-1, pos.col, pos.steps+1, '^')
    when WALKED; Pos.new(-1,-1,-1,WALKED) # indicate the infinite loop
    end
  end

  # The main logic of the program go here,
  #   and the logic to show it is infinite loop is
  #   when any prisms walk twice
  # Params:
  # +maze+: the maze array
  def total_steps(maze)
    pos = get_start_pos(maze)
    while(!is_reach_wall(pos, maze)) do
      pos = move(pos, maze)
    end
    pos.steps
  end

  # Get the input and create the maze
  def solve
    maze = []
    while(line = gets) do
      maze << line.strip.split('')
    end
    puts total_steps(maze).to_i
  end
end
