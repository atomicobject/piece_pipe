require 'spec_helper'

describe PiecePipe::HashedAggregator do
  let(:burps_and_chirps) do
    [
      {key: "burp", value: 2 },
      {key: "chirp", value: 2 },
      {key: "chirp", value: 3 },
      {key: "burp", value: 4 },
    ]
  end

  context "default impl" do
    it "produces the accumulated values for each key" do

      results = PiecePipe::Pipeline.new.
        source(burps_and_chirps).
        step(subject).
        to_a

      results[0].should == { key: "burp", values: [2,4] }
      results[1].should == { key: "chirp", values: [2,3] }
    end

    it "raises if the input items don't have :key and :value set" do
      lambda do ezpipe(subject, {}).to_a end.should raise_error(/key.*value/)
      lambda do ezpipe(subject, key: "ok").to_a end.should raise_error(/key.*value/)
      lambda do ezpipe(subject, value: "ok").to_a end.should raise_error(/key.*value/)
    end
  end

  context "custom #aggregate implementation" do
    class Countup < PiecePipe::HashedAggregator
      def aggregate(key,values)
        sum = values.inject do |a,b| a+b end
        produce [key, sum]
      end
    end

    it "creates output for each key" do
      results = PiecePipe::Pipeline.new.
        source(burps_and_chirps).
        step(Countup).
        to_a
      results[0].should == [ "burp", 6 ]
      results[1].should == [ "chirp", 5 ]
    end
  end

end

