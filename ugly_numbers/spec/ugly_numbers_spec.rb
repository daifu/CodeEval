require_relative 'spec_helper'
require_relative '../ugly_numbers'

describe UglyNumbers do

  before :each do
    @un = UglyNumbers.new('in')
  end

  describe "integration test" do
    it "should return correct output" do
      tests           = ['1', '9', '011', '12345', '7329']
      expected_return = [0, 1, 6, 64, 23]
      tests.each_with_index do |t, idx|
        @un.num_of_ugly_numbers(t).should == expected_return[idx]
      end
    end
  end

  describe "unit test" do
    it "should return all possible string" do
      tests           = ['1', '9', '012', '12', '7329']
      expected_return = [['1'], ['9'], ["012", "01-2", "01+2", "0-12", "0-1-2", "0-1+2", "0+12", "0+1-2", "0+1+2"],["12", "1-2", "1+2"], ["7329", "732-9", "732+9", "73-29", "73-2-9", "73-2+9", "73+29", "73+2-9", "73+2+9", "7-329", "7-32-9", "7-32+9", "7-3-29", "7-3-2-9", "7-3-2+9", "7-3+29", "7-3+2-9", "7-3+2+9", "7+329", "7+32-9", "7+32+9", "7+3-29", "7+3-2-9", "7+3-2+9", "7+3+29", "7+3+2-9", "7+3+2+9"]]
      tests.each_with_index do |t, idx|
        @un.get_all_numbers(t).should == expected_return[idx]
      end
    end

    it "should return the correct sum of ugly numbers" do
      test = ["012", "01-2", "01+2", "0-12", "0-1-2", "0-1+2", "0+12", "0+1-2", "0+1+2"]
      @un.sum_ugly_numbers(test).should == 6
    end
  end

end

