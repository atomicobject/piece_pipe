require 'spec_helper'

describe PiecePipe::Collector do
  let(:key) { :the_key }
  subject { described_class.new(key) }

  let(:pipeline) { PiecePipe::Pipeline.new }

  context "processing hashes" do
    it "produces the single item pulled from incoming Hash as named by the key" do
      pipeline.
        source([
               {one: "1", two: "2", the_key: "big"},
               {one: "11", two: "22", the_key: "momma"}]).
               collect(:the_key).to_enum.to_a.should == [ "big", "momma" ]
    end
  end
end
