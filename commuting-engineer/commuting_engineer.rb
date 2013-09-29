require_relative './sorted_array'

class CommutingEngineer
  MAX_VALUE = 100000
  Node = Struct.new(:path, :min, :table, :cur_score)

  def initialize(file='in')
    @file = file
  end

  def haversine(lat1, long1, lat2, long2)
    radius_of_earth = 6378.14
    rlat1, rlong1, rlat2, rlong2 = [lat1, long1, lat2, long2].map { |d| as_radians(d)}
    dlon = rlong1 - rlong2
    dlat = rlat1 - rlat2

    a = power(Math.sin(dlat/2), 2) + Math.cos(rlat1) * Math.cos(rlat2) * power(Math.sin(dlon/2), 2)
    great_circle_distance = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    radius_of_earth * great_circle_distance
  end

  def as_radians(degrees)
    degrees * Math::PI/180
  end

  def power(num, pow)
    num ** pow
  end

  def distance(loc1, loc2)
    haversine(loc1[0], loc1[1], loc2[0], loc2[1])
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
    total   = table.reduce(0.0) {|sum, row| sum += row.min != MAX_VALUE ? row.min : 0}
    ele_max = table.map {|row| row.min != MAX_VALUE ? row.min : 0}.max
    total - ele_max
  end

  def create_sorted_ary
    return SortedArray.new do |x, y|
      is_x_greater = x.min <=> y.min
      if is_x_greater == 0 #they are equal
        x.cur_score <=> y.cur_score
      else
        is_x_greater
      end
    end
  end

  def min_route(locations)
    table = build_distance_table(locations)
    min  = min_score(table)
    node = Node.new([0], min, table, 0)
    total = locations.size.times.to_a
    nodes = create_sorted_ary
    nodes << node
    return loop do
      node = nodes.slice!(0)
      nexts = adjacent_nodes(node, total)
      break node.path if nexts.size == 0
      nexts.each do |n|
        nodes << n
      end
    end
  end

  def solve
    locations = prepare(@file)
    min_route(locations).map {|i| i+1}
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
