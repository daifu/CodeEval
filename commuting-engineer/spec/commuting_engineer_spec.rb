require_relative './spec_helper'
require_relative '../commuting_engineer'

describe CommutingEngineer do
  before :each do
    @list = [
      "CodeEval 1355 Market St, SF (37.7768016, -122.4169151)",
      "Yelp 706 Mission St, SF (37.7860105, -122.4025377)",
      "Square 110 5th St, SF (37.7821494, -122.4058960)",
      "Airbnb 99 Rhode Island St, SF (37.7689269, -122.4029053)",
      "Dropbox 185 Berry St, SF (37.7768800, -122.3911496)",
      "Zynga 699 8th St, SF (37.7706628, -122.4040139)"
    ]
    @ce = CommutingEngineer.new
    @locations = [[37.7768016, -122.4169151],
                  [37.7860105, -122.4025377],
                  [37.7821494, -122.4058960],
                  [37.7689269, -122.4029053],
                  [37.7768800, -122.3911496],
                  [37.7706628, -122.4040139]]
    @simple    = [[0,0], [1,1], [1,0], [2,1]]
    @medium    = [[0,0], [0,4], [5,3], [5,0], [3,4], [0,3]]
  end
  describe 'distance' do
    it "should get the distance based on 2 different points" do
      (@ce.distance([4,-3], [1, -10]) - 7.61577).should < 0.01
    end
  end

  describe 'solve' do
    it "should prepare the locations" do
      @ce.prepare('in').should == @locations
    end

    context "with correct input" do
      before :each do
        @max = CommutingEngineer::MAX_VALUE
        @table = [[@max, 2**(1/2.0), 1, 5**(1/2.0)],
                 [2**(1/2.0), @max, 1, 1],
                 [1, 1, @max, 2**(1/2.0)],
                 [5**(1/2.0), 1, 2**(1/2.0), @max]]
      end
      it "should return minmum distance" do
        @ce.rec_min_distnace_wrapper(@simple).should == 3
        (@ce.rec_min_distnace_wrapper(@medium) - 12.2360679775) < 0.001
      end

      it "should receive an array of locations"

      it "should build a correct table" do
        @ce.build_distance_table(@simple).should == @table
      end

      it "should get the min score of the table" do
        @ce.min_score(@table).should == 3
      end

      it "should delete x row and y col from table" do
        @ce.mark_x_row_y_col_to_max(@table, 0, 0).should == [[@max, @max, @max, @max],
                                                             [@max, @max, 1, 1],
                                                             [@max, 1, @max, 2**(1/2.0)],
                                                             [@max, 1, 2**(1/2.0), @max]]
      end

      it "should return the min route" do
        ret = @ce.min_route(@medium)
        debugger
        puts "hello world"
        #@ce.min_route(@simple).should == [0,2,1,3]
        #@ce.min_route(@medium).should == [0, 2, 4, 5, 3, 1]
        #@ce.min_route(@locations).should == [1,3,2,5,6,4]
        #@ce.min_route(@locations).should == [0,2,1,4,5,3]
      end
    end

  end
end
