require_relative './spec_helper'
require_relative '../sorted_array'
require_relative '../commuting_engineer'

describe SortedArray do
  before :each do
    node = CommutingEngineer::Node
    @node_ary = [node.new([], 31, [], 20), node.new([], 34, [], 25), node.new([], 34, [], 26), node.new([], 38, [], 30)]
    @sa = SortedArray.new do |x, y|
      is_x_greater = x.min <=> y.min
      if is_x_greater == 0 #they are equal
        x.cur_score <=> y.cur_score
      else
        is_x_greater
      end
    end
  end
  it "should keep the array is sorted while inserting" do
    Node = CommutingEngineer::Node
    @sa << Node.new([], 34, [], 26)
    @sa << Node.new([], 34, [], 25)
    @sa << Node.new([], 31, [], 20)
    @sa << Node.new([], 38, [], 30)
    @sa.should == @node_ary
  end

end
