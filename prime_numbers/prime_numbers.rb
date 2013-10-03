class PrimeNumbers

  def initialize(file)
    @file = file
  end

  def is_prime(num)
    2.upto(num-1) do |i|
      return false if num % i == 0
    end
    return true
  end

  def print_prime_under_x(max)
    return if max < 2
    print '2'
    3.upto(max-1) do |i|
      print ",#{i}" if is_prime(i)
    end
  end

  def solve
    File.open(@file).map(&:strip).each do |num|
      print_prime_under_x(num.to_i)
      puts
    end
  end
end
