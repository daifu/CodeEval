# Bill Gates is on one of his philanthropic journeys to a village in Utopia. He has N packets of candies and would like to distribute one packet to each of the K children in the village (each packet may contain different number of candies). To avoid a fight between the children, he would like to pick K out of N packets such that the unfairness is minimized.
#
# Suppose the K packets have (x1, x2, x3,….xk) candies in them, where xi denotes the number of candies in the ith packet, then we define unfairness as
#
# max(x1,x2,…xk) - min(x1,x2,…xk)
#
# where max denotes the highest value amongst the elements and min denotes the least value amongst the elements. Can you figure out the minimum unfairness and print it?

class AngryChildren

  def subset_length(list, k)
    list.inject([[]]) do |powerset, element|
      powerset +
      powerset.map do |old_element|
        if old_element.length < k
          old_element + [element]
        else
          Array.new(k + 1) #will be rejected and it will not disturb when creating new subsets
        end
      end
    end.reject { |solution| solution.length != k }
  end

  def minimum_unfairness(numbers, cap)
    subset_length(numbers, cap).map {|nums| calculate(nums)}.min
  end

  def calculate(ary)
    (ary.max - ary.min).to_i
  end

  def solve
    lines   = gets
    cap     = gets
    numbers = []
    1.step(lines.to_i, 1) do
      num = gets
      numbers << num.to_i
    end
    puts minimum_unfairness(numbers, cap.to_i)
  end

end
