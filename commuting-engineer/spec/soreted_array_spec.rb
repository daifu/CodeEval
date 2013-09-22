require_relative './spec_helper'
require_relative '../sorted_array'
require_relative '../commuting_engineer'

describe SortedArray do
  before :each do
    Node = CommutingEngineer::Node
    @node_ary = [Node.new([], 31, []), Node.new([], 34, []), Node.new([], 34, []), Node.new([], 38, [])]
    @sa = SortedArray.new do |x, y|
      x.min <=> y.min
    end
  end
  it "should keep the array is sorted while inserting" do
    Node = CommutingEngineer::Node
    @sa << Node.new([], 34, [])
    @sa << Node.new([], 34, [])
    @sa << Node.new([], 31, [])
    @sa << Node.new([], 38, [])
    @sa.should == @node_ary
  end

end
