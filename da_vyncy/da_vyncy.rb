require_relative 'sorted_array'

class DaVyncy

  MIN_VALUE = 0
  Node = Struct.new(:path, :cur_score, :sentence)

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
      abs_max = [cur_max, abs_max].max if (i+cur_max == front.size) || (cur_max == back.size)
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
      y.cur_score <=> x.cur_score
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
  # merge 2 strings by removing common chars
  #
  def merge(front, back)
    length = overlay_length(front, back)
    front+back[length..-1]
  end

  #
  # Get all the adjacents nodes by one node
  #
  def adjacent_nodes(node, strings, table)
    path    = node.path
    last_x  = path[-1]
    choices = all_choices(strings.size).select {|t| !path.include?(t)}
    nodes   = create_sorted_ary
    choices.each do |c|
      score        = table[last_x][c]
      path         = node.path+[c]
      cur_sentence = merge(node.sentence, strings[c])
      nodes << Node.new(path, score, cur_sentence)
    end
    nodes.first(1)
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
        path         = [row_index, col_index]
        cur_score    = col
        cur_sentence = merge(strings[row_index], strings[col_index])
        queue << Node.new(path, cur_score, cur_sentence)
      end
    end
    queue
  end

  #
  # use branch and bound algorithm to find the best solution
  # if a node with the max score and current score (score is
  # calculated based on how many match)
  #
  def get_sentence(queue, strings, table)
    return loop do
      node  = queue.slice!(0)
      nexts = adjacent_nodes(node, strings, table)
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
    get_sentence(queue, strings, table)
  end

  def solve
    File.open(@file).map(&:strip).each do |str|
      puts sentence(str)
    end
  end

end
