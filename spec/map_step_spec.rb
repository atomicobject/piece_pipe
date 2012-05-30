require 'spec_helper'

describe PiecePipe::MapStep do
  context "default impl" do
    it "maps the input item to itself" do
      ezpipe(subject, "hello").to_a.first.should == {key: "hello", value: "hello"}
    end
  end
  
  context "sample subclass of MapStep" do
    class MyMapping < PiecePipe::MapStep
      def map(item)
        emit item[:name], item[:age]
      end
    end

    subject do MyMapping.new end

    it "can use #emit to produce Hashes w :key and :value set" do
      ezpipe(subject, name: "Cosby", age: 65).to_a.first.should == {key:"Cosby", value: 65}
    end
  end
end
