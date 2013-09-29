require_relative 'sorted_array'

class DaVyncy

  MIN_VALUE = 0
  Node = Struct.new(:max, :path, :cur_score, :table, :sentence)

  def initialize(file='in')
    @file = file
  end

  #
  # This is the method to calculate the score between
  # 2 strings, since the position is important for 2 strings
  #
  def overlay_length(front, back)
    cur_max = 0
    abs_max = 0
    0.upto(front.size - 1) do |i|
      0.upto(back.size - 1) do |j|
        break if front[i+j] != back[j] || i+j > front.size
        cur_max += 1
      end
      abs_max = [cur_max, abs_max].max if i+cur_max == front.size
      cur_max = 0
    end
    abs_max
  end

  #
  # Create a table that contains all the score between
  # 2 strings
  #
  def build_table(strings)
    size  = strings.size
    table = []
    0.upto(size - 1).each {|i| table << []} #init table
    0.upto(size-1) do |i|
      0.upto(size-1) do |j|
        if i == j
          table[i][j] = MIN_VALUE
        else
          table[i][j] = overlay_length(strings[i], strings[j])
        end
      end
    end
    table
  end

  def parse(str)
    str.split(';')
  end

  #
  # get the potential max score by just all all
  # the max of each row
  #
  def expected_max_score(table)
    table.reduce(0) {|sum, row| sum += row.max}
  end

  #
  # Created sorted array object from sorted_array.rb
  #
  def create_sorted_ary
    return SortedArray.new do |x, y|
      is_y_greater = y.max <=> x.max
      if is_y_greater == 0 #they are equal
        y.cur_score <=> x.cur_score
      else
        is_y_greater
      end
    end
  end

  #
  # Mark row x and col y to max means we cannot use it.
  #
  def mark_x_row_y_col_to_min(table, x, y)
    new_table = Marshal.load(Marshal.dump(table))
    new_table[x] = [MIN_VALUE] * new_table[x].size

    new_table.size.times.each do |i|
      new_table[i][y] = MIN_VALUE
    end
    new_table
  end

  #
  # create [0,1,2...size-1]
  #
  def all_choices(size_of_x_axis)
    size_of_x_axis.times.to_a
  end

  #
  # Get all the adjacents nodes by one node
  #
  def adjacent_nodes(node, strings)
    path    = node.path
    last_x  = path[-1]
    choices = all_choices(strings.size).select {|t| !path.include?(t)}
    nodes   = []
    choices.each do |c|
      path           = node.path+[c]
      score          = node.cur_score+node.table[last_x][c]
      filtered_table = mark_x_row_y_col_to_min(node.table, last_x, c)
      max            = expected_max_score(filtered_table)+score
      cur_sentence   = node.sentence+strings[c][node.table[last_x][c]..-1]
      nodes << Node.new(max, path, score, filtered_table, cur_sentence)
    end
    nodes
  end

  #
  # create the initial queue to start, since we dont know
  # where to start and the start is very important
  #
  def build_queue(table, strings)
    queue = create_sorted_ary
    table.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        next if row_index == col_index
        next if col == 0
        path           = [row_index, col_index]
        cur_score      = col
        filtered_table = mark_x_row_y_col_to_min(table, row_index, col_index)
        max            = expected_max_score(filtered_table)+col
        cur_sentence   = strings[row_index]+strings[col_index][table[row_index][col_index]..-1]
        queue << Node.new(max, path, cur_score, filtered_table, cur_sentence)
      end
    end
    queue
  end

  #
  # use branch and bound algorithm to find the best solution
  # if a node with the max score and current score (score is
  # calculated based on how many match)
  #
  def get_sentence(queue, strings)
    return loop do
      node  = queue.slice!(0)
      nexts = adjacent_nodes(node, strings)
      break node.sentence if nexts.size == 0 && node.path.size == strings.size
      nexts.each do |n|
        queue << n
      end
    end
  end

  #
  # main logic:
  #   get the input
  #   create a scoring table
  #   find out where to start and save time
  #   used branch and bound algorithm to find out the solution
  #
  def sentence(str)
    strings = parse(str)
    table   = build_table(strings)
    queue   = build_queue(table, strings)
    get_sentence(queue, strings)
  end

  def solve
    File.open(@file).map(&:strip).each do |str|
      puts sentence(str)
    end
  end

end
