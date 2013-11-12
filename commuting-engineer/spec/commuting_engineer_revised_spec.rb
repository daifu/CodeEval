require_relative './spec_helper'
require_relative '../commuting_engineer_revised'

describe Solver do
  before :each do
    @solver = Solver.new
    simple_locations = [[0,0], [1,1], [1,0], [2,1]]
    medium_locations = [[0,0], [0,4], [5,3], [5,0], [3,4], [0,3]]
    @simple = Destinations.new(simple_locations)
    @medium = Destinations.new(medium_locations)
  end

  describe "solve" do
    it "should return the correct orders for the destination" do
      @solver.stub(:create_locations_from_file).and_return(@simple)
      @solver.solve.should == [1,3,2,4]
      @solver.stub(:create_locations_from_file).and_return(@medium)
      @solver.solve.should == [1,6,2,5,3,4]
    end
  end
end
