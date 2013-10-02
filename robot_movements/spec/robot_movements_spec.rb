require_relative 'spec_helper'
require_relative '../robot_movements'

describe RobotMovements do

  describe 'num_of_ways' do
    it "should get the correct number of ways" do
      rb = RobotMovements.new
      rb.num_of_ways.should == 10
    end
  end


end

