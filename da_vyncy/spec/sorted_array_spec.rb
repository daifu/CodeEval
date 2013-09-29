require_relative 'spec_helper'
require_relative '../sorted_array'
require_relative '../da_vyncy'

describe SortedArray do

  it "should insert based on descending order" do
    queue = SortedArray.new do |x, y|
      is_y_greater = y.max <=> x.max
      if is_y_greater == 0 #they are equal
        y.cur_score <=> x.cur_score
      else
        is_y_greater
      end
    end
    node = DaVyncy::Node
    queue << node.new(20, [], 15)
    queue << node.new(10, [], 5)
    queue << node.new(20, [], 13)
    queue << node.new(30, [], 20)
    queue << node.new(4, [], 3)
    queue << node.new(25,[], 19)
    queue << node.new(12, [], 10)
    queue.should == [node.new(30, [], 20), node.new(25,[], 19), node.new(20, [], 15), node.new(20, [], 13), node.new(12, [], 10), node.new(10, [], 5), node.new(4, [], 3)]
  end

end
