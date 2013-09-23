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
      (@ce.distance([4,-3], [1, -10]) - 847.01966936).should < 0.01
    end
  end

  describe 'solve' do
    it "should prepare the locations" do
      @ce.prepare('in').should == @locations
    end

    context "with correct input" do
      before :each do
        @max = CommutingEngineer::MAX_VALUE
        sq_2 = 2**(1/2.0)
        sq_5 = 5**(1/2.0)
        dis1 = 157.4256111545812
        dis2 = 111.31954315315113
        dis3 = 248.90795451217213
        dis4 = 111.30258821723933
        dis5 = 157.4016350807274
        @table = [[@max, dis1, dis2, dis3],
                 [dis1,  @max, dis4, dis2],
                 [dis2,  dis4, @max, dis5],
                 [dis3,  dis2, dis5, @max]]
        node  = CommutingEngineer::Node
        @node1       =  node.new([0], 3.0, @table, 0)
        @node1_nexts = [node.new([0,2], 333.94167452354156, @ce.mark_x_row_y_col_to_max(@table, 0,2), 111.31954315315113),
                        node.new([0,1], 380.0477425249717,   @ce.mark_x_row_y_col_to_max(@table, 0,1), 157.4256111545812),
                        node.new([0,3], 471.5131309466508,   @ce.mark_x_row_y_col_to_max(@table, 0,3), 248.90795451217213)]
        @node2       = @node1_nexts.first
        @node2_nexts = [node.new([0,2,1], 333.94167452354156, @ce.mark_x_row_y_col_to_max(@node2.table, 2,1), 222.62213137039046),
                        node.new([0,2,3], 380.04072138702963, @ce.mark_x_row_y_col_to_max(@node2.table, 2,3), 268.7211782338785)]
        @node3       = @node2_nexts.first
        @node3_nexts = [node.new([0,2,1,3], 333.94167452354156, @ce.mark_x_row_y_col_to_max(@node3.table, 1,3), 333.94167452354156)]
        @node4       = @node3_nexts.first
        @node4_nexts = []
      end

      it "should return minmum distance" do
        @ce.rec_min_distnace_wrapper(@simple).should == 333.94167452354156
        (@ce.rec_min_distnace_wrapper(@medium) - 12.2360679775) < 0.001
      end

      it "should build a correct table" do
        @ce.build_distance_table(@simple).should == @table
      end

      it "should get the min score of the table" do
        @ce.min_score(@table).should == 333.9247195876298
      end

      it "should delete x row and y col from table" do
        dis2 = 111.31954315315113
        dis4 = 111.30258821723933
        dis5 = 157.4016350807274
        @ce.mark_x_row_y_col_to_max(@table, 0, 0).should == [[@max, @max, @max, @max],
                                                             [@max, @max, dis4, dis2],
                                                             [@max, dis4, @max, dis5],
                                                             [@max, dis2, dis5, @max]]
      end

      it "should get the correct adjacent_nodes" do
        table = @ce.mark_x_row_y_col_to_max(@table, 0, 1)
        @ce.adjacent_nodes(@node1, [0,1,2,3]).should == @node1_nexts
        @ce.adjacent_nodes(@node2, [0,1,2,3]).should == @node2_nexts
        @ce.adjacent_nodes(@node3, [0,1,2,3]).should == @node3_nexts
        @ce.adjacent_nodes(@node4, [0,1,2,3]).should == @node4_nexts
      end

      it "should return the min route" do
        @ce.min_route(@simple).should == [0,2,1,3]
        @ce.min_route(@medium).should == [0,5,1,4,2,3]
        @ce.min_route(@locations).should == [0,2,1,4,5,3]
      end

      it "should return the correct order" do
        @ce.stub(:prepare).and_return(@simple)
        @ce.solve.should == [1,3,2,4]
        @ce.stub(:prepare).and_return(@medium)
        @ce.solve.should == [1,6,2,5,3,4]
        @ce.stub(:prepare).and_return(@locations)
        @ce.solve.should == [1,3,2,5,6,4]
      end
    end

  end
end
