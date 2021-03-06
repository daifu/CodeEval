require_relative 'spec_helper'
require_relative '../da_vyncy'

describe DaVyncy do

  before :each do
    @dv    = DaVyncy.new()
    @min   = DaVyncy::MIN_VALUE
    @test1 = 'O draconia;conian devil! Oh la;h lame sa;saint!'
    @test2 = 'm quaerat voluptatem.;pora incidunt ut labore et d;, consectetur, adipisci velit;olore magnam aliqua;idunt ut labore et dolore magn;uptatem.;i dolorem ipsum qu;iquam quaerat vol;psum quia dolor sit amet, consectetur, a;ia dolor sit amet, conse;squam est, qui do;Neque porro quisquam est, qu;aerat voluptatem.;m eius modi tem;Neque porro qui;, sed quia non numquam ei;lorem ipsum quia dolor sit amet;ctetur, adipisci velit, sed quia non numq;unt ut labore et dolore magnam aliquam qu;dipisci velit, sed quia non numqua;us modi tempora incid;Neque porro quisquam est, qui dolorem i;uam eius modi tem;pora inc;am al'
  end

  describe "sentence" do
    it "should pass the simplest tests" do
      str = @test1
      @dv.sentence(str).should == 'O draconian devil! Oh lame saint!'
    end

    it "should pass the medium test" do
      str = "ABCDEF;DEFG;XYZABC;BCDE;XCDEZ"
      @dv.sentence(str).should == 'XYZABCDEFGXCDEZ'
    end

    it "should pass the hardest tests" do
      str = @test2
      res = 'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'
      #str = 'm quaerat voluptatem.;pora incidunt ut labore et d;, consectetur, adipisci velit;olore magnam aliqua;idunt ut labore et dolore magn;uptatem.;i dolorem ipsum qu;iquam quaerat vol;psum quia dolor sit amet, consectetur, a;ia dolor sit amet, conse'
      @dv.sentence(str).should == res
    end
  end


  describe "parse" do
    it "should split a long string into parts by ;" do
      @dv.parse(@test1).should == ['O draconia', 'conian devil! Oh la', 'h lame sa', 'saint!']
    end
  end

  describe "build_table" do
    it "should build a table of all the overlap length between all the strings" do
      table = [[@min, 5,    0,    0],
               [0,    @min, 4,    0],
               [0,    0,    @min, 2],
               [0,    0,    0,    @min]]
      @dv.build_table(['O draconia', 'conian devil! Oh la', 'h lame sa', 'saint!']).should == table
    end

    it "should works for back string insdie the front string" do
      table = [[0,3,0,4,0],[0,0,0,0,0],[3,0,0,2,0],[0,2,0,0,0],[0,0,0,0,0]]
      @dv.build_table("ABCDEF;DEFG;XYZABC;BCDE;XCDEZ".split(';')).should == table
    end
  end

  describe "build_queue" do
    it "should create a queue with all the nodes from the table and sorted in descending order" do
      table = [[@min, 5,    0,    0],
               [0,    @min, 4,    0],
               [0,    0,    @min, 2],
               [0,    0,    0,    @min]]
      node  = DaVyncy::Node
      #since the array is too long, I do not have that patient to write it out.
      @dv.build_queue(table, ['O draconia', 'conian devil! Oh la', 'h lame sa', 'saint!']).size.should == 3
    end
  end

  describe "adjacent_nodes" do
    it "should get all the possible adjacents node form the parent" do
      node  = DaVyncy::Node
      table = [[0, 0, 0, 0], [0, 0, 4, 0], [0, 0, 0, 2], [0, 0, 0, 0]]
      test  = node.new([0,1], 5,"O draconian devil! Oh la")
      nexts = @dv.adjacent_nodes(test, ['O draconia', 'conian devil! Oh la', 'h lame sa', 'saint!'], table)
      nexts.size.should == 1
    end
  end

end
