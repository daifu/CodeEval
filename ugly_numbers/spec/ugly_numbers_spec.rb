require_relative 'spec_helper'
require_relative '../ugly_numbers'

describe UglyNumbers do

  before :each do
    @un = UglyNumbers.new('in')
  end

  describe "integration test" do
    it "should return correct output" do
      tests           = ['1', '9', '011', '12345']
      expected_return = [0, 1, 6, 64]
      tests.each_with_index do |t, idx|
        @un.num_of_ugly_numbers(t).should == expected_return[idx]
      end
    end
  end

  describe "unit test" do
    it "should return all possible string" do
      tests           = ['1', '9', '012', '12']
      expected_return = [['1'], ['9'], ["012", "01-2", "01+2", "0-12", "0-1-2", "0-1+2", "0+12", "0+1-2", "0+1+2"],["12", "1-2", "1+2"]]
      tests.each_with_index do |t, idx|
        @un.rec_get_all_numbers(t).should == expected_return[idx]
      end
    end

    it "should evalute from string to number" do
      test            = ["011", "01-1", "01+1", "0-11", "0-1-1", "0-1+1", "0+11", "0+1-1", "0+1+1"]
      expected_return = {'-11' => 1, '-2' => 1, '0' => 3, '2' => 2, '11' => 2}
      @un.evaluate_to_hash(test).should == expected_return
    end

    it "should return the correct sum of ugly numbers" do
      test = {'-11' => 1, '-2' => 1, '0' => 3, '2' => 2, '11' => 2}
      @un.sum_ugly_numbers(test).should == 6
    end
  end

end

