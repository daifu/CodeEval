class UglyNumbers

  Node = Struct.new(:num, :idx, :cur_str)

  def initialize(file)
    @file = file
  end

  def get_all_numbers(str)
    return [str] if str.size == 1
    queue = []
    ret   = []
    queue.push(Node.new(str[0], 0, str[0]))
    while(queue.size > 0) do
      node = queue.slice!(0)
      ['', '-', '+'].each do |op|
        if node.idx+2 == str.size
          ret << node.cur_str+op+str[node.idx+1]
        else
          queue << Node.new(str[node.idx+1], node.idx+1, node.cur_str+op+str[node.idx+1])
        end
      end
    end
    ret
  end

  def evaluate(str)
    parts = str.split(/([0-9]+|-[0-9]+|\+[0-9]+)/)
    parts.reduce(0) {|sum, n| sum+=n.to_i}
  end

  def is_ugly(num)
    return num % 2 == 0 || num % 3 == 0 || num % 5 == 0 || num % 7 == 0
  end

  def sum_ugly_numbers(possible_res)
    sum = 0
    possible_res.each do |res|
      value = evaluate(res)
      sum += 1 if is_ugly(value)
    end
    sum
  end

  def num_of_ugly_numbers(str)
    possible_res = get_all_numbers(str)
    sum_ugly_numbers(possible_res)
  end

  def prepare(file_in)
    input = []
    File.open(file_in).map(&:strip).each do |address|
      input << address
    end
    input
  end

end
