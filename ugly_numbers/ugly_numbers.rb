class UglyNumbers

  def initialize(file)
    @file = file
  end

  def rec_get_all_numbers_helper(node, rest, max_size)
    return if @ret.size == max_size
    if rest.size == 0
      @ret << node unless @ret.include?(node)
      return
    end
    rest.each do |r|
      ['', '-', '+'].each do |op|
        rec_get_all_numbers_helper(node+op+r, rest[1..-1], max_size)
      end
    end
    return
  end

  def rec_get_all_numbers(str)
    @ret  = []
    str   = str.split('')
    first = str.slice!(0)
    rec_get_all_numbers_helper(first, str, 3**(str.size))
    @ret
  end

  def evaluate(str)
    parts = str.split(/([0-9]+|-[0-9]+|\+[0-9]+)/)
    parts.reduce(0) {|sum, n| sum+=n.to_i}
  end

  def evaluate_to_hash(possible_res)
    hash = {}
    possible_res.each do |str|
      res = evaluate(str)
      hash[res.to_s] ||= 0
      hash[res.to_s] += 1
    end
    hash
  end

  def is_ugly(num)
    return num == 0 || num % 2 == 0 || num % 3 == 0 || num % 5 == 0 || num % 7 == 0
  end

  def sum_ugly_numbers(hash)
    sum = 0
    hash.each do |key, value|
      sum += value if is_ugly(key.to_i)
    end
    sum
  end

  def num_of_ugly_numbers(str)
    possible_res  = rec_get_all_numbers(str)
    evaluated_res = evaluate_to_hash(possible_res)
    sum_ugly_numbers(evaluated_res)
  end

  def prepare(file_in)
    input = []
    File.open(file_in).map(&:strip).each do |address|
      input << address
    end
    input
  end

end
