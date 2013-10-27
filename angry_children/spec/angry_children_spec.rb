require_relative 'spec_helper'
require_relative '../angry_children'

describe AngryChildren do

  before :each do
    @ac = AngryChildren.new
  end

  describe 'fairness' do
    it "calculate the fairness correctly" do
      tests = [1,2,3,4,5]
      @ac.calculate(tests).should == 4
    end
  end

  describe 'subset_length' do
    it "should return all length of 2 subset" do
      @ac.subset_length([1,2,3,4], 2).should == [[1, 2], [1, 3], [2, 3], [1, 4], [2, 4], [3, 4]]
    end
  end

  describe 'integration test' do
    it "should pass" do
      tests= [10,100,300,200,1000,20,30]
      @ac.minimum_unfairness(tests, 3).should == 20

      tests2 = [1,2,3,4,10,20,30,40,100,200]
      @ac.minimum_unfairness(tests2, 4).should == 3
    end
  end

end

