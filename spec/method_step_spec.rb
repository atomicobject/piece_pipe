require 'spec_helper'

describe PiecePipe::MethodStep do
  let(:pipeline) { PiecePipe::Pipeline.new }

  context "wrapping methods with single arguments" do
    it "creates a pipeline step that produces the return of the Method" do
      pipeline.
        input(42).
        step( method(:stringify_number) ).
        to_enum.to_a.should == ["!42!"]
    end

    it "produces nil if the method returns nothing" do
      pipeline.
        input(42).
        step( method(:do_nothing) ).
        to_enum.to_a.should == [nil]
    end
  end

  context "wrapping methods with single arguments" do
    it "creates a pipeline step wrapped around a Method, providing a 'producer' object as the second argument" do
      pipeline.
        input(3).
        step( method(:spew_strings) ).
        to_enum.to_a.should == [ ">>3", ">>3", ">>3" ]
    end

    it "produces NOTHING if the method doesn't invoke producer.produce" do
      pipeline.
        input(42).
        step( method(:do_nothing2) ).
        to_enum.to_a.should == []
    end
  end

  it "raises an error if null is provided" do
    lambda do pipeline.input(42).step( nil ) end.should raise_error(/nil/)
  end

  it "raises an error if arity is 0" do
    lambda do pipeline.input(42).step( method(:no_args) ) end.should raise_error(/arguments/)
  end

  it "raises an error if arity greater than 2" do
    lambda do pipeline.input(42).step( method(:three_args) ) end.should raise_error(/arguments.* 3/)
  end

  it "raises an error if arity is abitrary" do
    lambda do pipeline.input(42).step( method(:many_args) ) end.should raise_error(/arguments.* -1/)
  end

  #
  # HELPERS
  #

  def stringify_number(num)
    "!#{num}!"
  end

  def do_nothing(num)
  end
  
  def spew_strings(num,producer)
    num.times do 
      producer.produce ">>#{num}"
    end
  end

  def do_nothing2(num,producer)
  end

  def no_args
    "should not work"
  end

  def three_args(a,b,c)
    "still should not work"
  end

  def many_args(*a)
    "still should not work at all"
  end

end
