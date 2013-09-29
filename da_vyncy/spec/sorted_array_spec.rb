require_relative 'spec_helper'
require_relative '../sorted_array'
require_relative '../da_vyncy'

describe SortedArray do

  it "should insert based on descending order" do
    queue = SortedArray.new do |x, y|
      y.cur_score <=> x.cur_score
    end
    node = DaVyncy::Node
    queue << node.new([],20,'')
    queue << node.new([],10,'')
    queue << node.new([],20,'')
    queue << node.new([],30,'')
    queue << node.new([],4,'')
    queue << node.new([],25,'')
    queue << node.new([],12,'')
    queue.should == [node.new([],30,''), node.new([],25,''), node.new([],20,''), node.new([],20,''), node.new([],12,''), node.new([],10,''), node.new([],4,'')]
  end

end
