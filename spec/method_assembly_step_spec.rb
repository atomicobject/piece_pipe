require 'spec_helper'

describe PiecePipe::MethodAssemblyStep do
  let(:pipeline) { PiecePipe::Pipeline.new }

  context "wrapping methods with single arguments" do
    it "creates a pipeline step that 'installs' the hash returned from the Method" do
      pipeline.
        input(a: 1, b: 2).
        assembly_step( method(:sum_a_b) ).
        to_enum.to_a.should == [{a: 1, b: 2, sum: 3}]
    end

    it "produces unchanged if the method returns an empty hash" do
      pipeline.
        input(a: 1, b: 2).
        assembly_step( method(:return_empty_hash) ).
        to_enum.to_a.should == [{a:1, b:2}]
    end

    it "produces unchanged if the method returns nothing" do
      pipeline.
        input(a: 1, b: 2).
        assembly_step( method(:return_nothing) ).
        to_enum.to_a.should == [{a:1, b:2}]
    end

  end

  #
  # HELPERS
  #

  def sum_a_b(inputs)
    { sum: inputs[:a] + inputs[:b] }
  end

  def return_empty_hash(inputs)
    { }
  end

  def return_nothing(inputs)
  end


end
