require_relative 'spec_helper'
require_relative '../lazer_maze_revised'

describe LazerMaze do
  before :each do
    @lm = LazerMaze.new
    @maze = get_maze(['@--','---','---'])
  end

  it "should create a maze instance" do
    @lm.stub(:build_maze)
    @lm.maze.should == []
  end

  it "should get the correct start" do
    @lm.maze = @maze
    @lm.start.should == {row: 0, col: 0}
  end

end

describe Solver do

  before :each do
    @s = Solver.new
    @s.maze.stub(:build_maze)
  end

  describe "solve" do
    it "should pass the sample without prisms" do
      maze = get_maze(['@--','---','---'])
      @s.maze.maze = maze
      @s.solve.should == 3
    end

    it "should get correct res with prisms" do
      maze = get_maze(['@-v','---','---'])
      @s.maze.maze = maze
      @s.solve.should == 5
    end

    it "should get correct res with prisms1" do
      maze1 = get_maze(['@-v-','----','--<-'])
      @s.maze.maze = maze1
      @s.solve.should == 7
    end

    it "should get correct res with prisms2" do
      maze2 = get_maze(['@-v','---','-^<'])
      @s.maze.maze = maze2
      @s.solve.should == 8
    end

    it "should get correct res with prisms3" do
      maze3 = get_maze(['@-v','->-','-^<'])
      @s.maze.maze = maze3
      @s.solve.should == 8
    end

    it "should get correct res with prisms4" do
      maze = get_maze(['@-v','->v','-^<'])
      @s.maze.maze = maze
      @s.solve.should == -1
    end
  end

end

