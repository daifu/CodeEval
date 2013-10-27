# Little Bob loves chocolates and goes to the store with a $N bill with $C being the price of each chocolate. In addition, the store offers a discount: for every M wrappers he gives the store, he’ll get one chocolate for free. How many chocolates does Bob get to eat?
#
# Input Format:
# The first line contains the number of test cases T (<=1000).
# Each of the next T lines contains three integers N, C and M
#
# Output Format:
# Print the total number of chocolates Bob eats.

class ChocolateFeast

  def total_chocolate(total, cost, wrappers)
    num = total / cost
    num += get_chocolate_by_wrappers(num, wrappers)
    num
  end

  def get_chocolate_by_wrappers(num, wrappers)
    if num < wrappers
      return 0
    end
    num / wrappers + get_chocolate_by_wrappers(num / wrappers + num % wrappers, wrappers)
  end

  def solve
    lines = gets
    1.step(lines.to_i, 1) do
      line = gets
      total, cost, wrappers = line.split(' ')
      total_chocolate(total.to_i, cost.to_i, wrappers.to_i)
    end
  end

end

cf = ChocolateFeast.new
cf.solve
