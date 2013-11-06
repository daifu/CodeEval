require_relative 'spec_helper'
require_relative '../lazer_maze'

describe LazerMaze do
  before :each do
    @lm = LazerMaze.new
    @pos = LazerMaze::Pos
    @maze = ['@--','---','---']
    @maze = @maze.map {|line| line.split('')}
  end

  describe "get_start_pos" do
    it "should get the correct start pos" do
      p  = @pos.new(0,0,0,'>')
      @lm.get_start_pos(@maze).should == p
    end
  end

  describe "is_reach_wall" do
    it "should return fasle if not reached the wall" do
      p = @pos.new(1,0)
      @lm.is_reach_wall(p, @maze).should == false
    end

    it "should return true if reached the wall" do
      p = @pos.new(3,0)
      @lm.is_reach_wall(p, @maze).should == true
    end
  end

  describe "total_steps" do
    it "should get correct res with no prisms" do
      @lm.total_steps(@maze).should == 3
    end

    it "should get correct res with prisms" do
      maze = get_maze(['@-v','---','---'])
      @lm.total_steps(maze).should == 5
    end


    it "should get correct res with prisms1" do
      maze1 = get_maze(['@-v-','----','--<-'])
      @lm.total_steps(maze1).should == 7
    end

    it "should get correct res with prisms2" do
      maze2 = get_maze(['@-v','---','-^<'])
      @lm.total_steps(maze2).should == 8
    end

    it "should get correct res with prisms3" do
      maze3 = get_maze(['@-v','->-','-^<'])
      @lm.total_steps(maze3).should == 8
    end

    it "should get correct res with prisms4" do
      maze = get_maze(['@-v','->v','-^<'])
      @lm.total_steps(maze).should == -1
    end
  end

end
