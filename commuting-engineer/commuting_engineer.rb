require_relative './sorted_array'

class CommutingEngineer
  MAX_VALUE = 100000
  Node = Struct.new(:path, :min, :table, :cur_score)

  def initialize(file='in')
    @file = file
  end

  def distance(loc1, loc2)
    ((loc1[0] - loc2[0])**2 + (loc1[1] - loc2[1])**2)**(1/2.0)
  end

  def rec_min_distance(start, locations)
    if locations.size == 0
      return 0
    else
      distances = []
      locations.each_with_index do |loc, i|
        distances << (rec_min_distance(loc, locations[0...i]+locations.drop(i+1)) + distance(start, loc))
      end
      return distances.min
    end
  end

  def rec_min_distnace_wrapper(locations)
    rec_min_distance(locations[0], locations[1..-1])
  end

  def adjacent_nodes(node, total)
    path    = node.path
    last_x  = path[-1]
    choices = total.select {|t| !path.include?(t)}
    nodes   = []
    choices.each do |c|
      score = node.cur_score+node.table[last_x][c]
      filtered_table = mark_x_row_y_col_to_max(node.table, last_x, c)
      nodes << Node.new(path+[c], min_score(filtered_table)+score, filtered_table, score)
    end
    debugger
    nodes
  end

  def mark_x_row_y_col_to_max(table, x, y)
    new_table = Marshal.load(Marshal.dump(table))
    new_table[x] = [MAX_VALUE] * new_table[x].size

    new_table.size.times.each do |i|
      new_table[i][y] = MAX_VALUE
    end
    new_table
  end

  def build_distance_table(locations)
    table = []
    size  = locations.size
    size.times.each {table << []}
    (0...size).each do |i|
      (0...size).each do |j|
        if i == j
          table[i][j] = MAX_VALUE
        else
          table[i][j] = distance(locations[i], locations[j])
        end
      end
    end
    table
  end

  def min_score(table)
    min_ary = []
    table.each do |row|
      min_ary << (row.min != MAX_VALUE ? row.min : 0)
    end
    max_ele = min_ary.max
    min_ary.reduce(0.0) {|sum, ele| sum += ele} - max_ele
  end

  def min_route(locations)
    sorted_ary = SortedArray.new do |x, y|
      x.min <=> y.min
    end
    table = build_distance_table(locations)
    min  = min_score(table)
    node = Node.new([0], min, table, 0)
    total = locations.size.times.to_a
    sorted_ary << node
    return loop do
      node = sorted_ary.slice!(0)
      nexts = adjacent_nodes(node, total)
      break node if nexts.size == 0
      nexts.each do |n|
        sorted_ary << n
      end
      debugger
      break node if (sorted_ary.size < 0)
    end
  end

  def solve
    locations = prepare(@file)
    min_route(locations)
  end

  def prepare(file_in)
    input = []
    regx  = /-*[0-9]+\.[0-9]+/

    File.open(file_in).map(&:strip).each do |address|
      input << address.scan(regx).map {|str| str.to_f}
    end
    input
  end

end
