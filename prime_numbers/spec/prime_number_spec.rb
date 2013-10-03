require_relative 'stdout_helper'
require_relative 'spec_helper'
require_relative '../prime_numbers'

describe PrimeNumbers do

  before :each do
    @pn = PrimeNumbers.new('in')
  end

  describe 'is_prime' do
    it "should return if the number is prime" do
      @pn.is_prime(2).should  be_true
      @pn.is_prime(6).should  be_false
      @pn.is_prime(10).should be_false
      @pn.is_prime(13).should be_true
      @pn.is_prime(53).should be_true
    end
  end

  describe "print_prime_under_x"  do
    it "should print out the correct list of prime number" do
      printed = capture_stdout do
        @pn.print_prime_under_x(100)
      end
      printed.should == "2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97"
    end
  end

end
