require 'spec_helper'

describe PiecePipe::GroupByStep do
  
  context "grouping by a subset" do

    it "groups by a single key" do
      subject = PiecePipe::GroupByStep.new(:last)
      inputs = [ { first: 'David', last: 'Crosby', age: 65 },
                 { first: 'Bill', last: 'Crosby', age: 67 } ]

      PiecePipe::Pipeline.new.
        source(inputs).
        step(subject).to_a.first.should == {
        "Crosby" => inputs
      }

      # ezpipe(subject,inputs)
    end

    it "groups by multiple keys" do
      subject = PiecePipe::GroupByStep.new(:last, :first)
      inputs = { first: 'David', last: 'Crosby', age: 65 }
      ezpipe(subject,inputs).to_a.first.should == {
        ["Crosby", 'David'] => [inputs]
      }

    end
  end
end
