require 'spec_helper'

describe PiecePipe::Step do

  let (:array_source) { [ "hippo", "distribution", "mechanism" ] }

  context "default Step" do

    it "provides an enumeration of its source's elements" do
      e = PiecePipe::Step.new
      e.source = array_source
      
      en = e.to_enum
      en.next.should == "hippo"
      en.next.should == "distribution"
      en.next.should == "mechanism"
      lambda do en.next end.should raise_error(StopIteration)
    end
  end

  context "overriding #generate_sequence" do 
    class IntegerGenerator < PiecePipe::Step
      def generate_sequence
        process 1
        process 2
        process 3
      end
    end

    it "can produce a sequence of items by invoking #process multiple times" do
      en = IntegerGenerator.new.to_enum
      en.to_a.should == [1,2,3]
    end

    class NothingGenerator < PiecePipe::Step
      def generate_sequence
        
      end
    end


    it "can produce an empty enumerator by never invoking #process" do
      en = NothingGenerator.new.to_enum
      en.to_a.should == []
    end

    context "bypassing the default #process invocation" do
    class IntegerProducer < PiecePipe::Step
      def generate_sequence
        produce 1
        produce 2
        produce 3
      end
    end

      it "can produce a sequence of items by invoking #produce multiple times" do
        en = IntegerProducer.new.to_enum
        en.to_a.should == [1,2,3]
      end

    class NothingProducer < PiecePipe::Step
      def generate_sequence

      end
    end

      it "can produce an empty enumerator by never invoking #produce" do
        en = NothingProducer.new.to_enum
        en.to_a.should ==[]
      end
    end
  end

  context "overriding #process" do
    class StringExpander < PiecePipe::Step
      def  process(item)
        produce "x" * item
      end
    end

    it "can transform a sequence of items" do
      se = StringExpander.new
      se.source = [2,4]
      se.to_enum.to_a.should == ["xx", "xxxx"]
    end

    class AllFilter < PiecePipe::Step
      def process(item)

      end
    end

    it "can filter items out of a sequence by neglecting to call #produce" do
      al = AllFilter.new
      al.source = [3,6]
      al.to_enum.to_a.should == []
    end

    class Exploder < PiecePipe::Step
      def process(item)
        item.times do
          produce "hi #{item}"
        end
      end
    end

    it "can inflate a sequence by invoking #produce multiple times per item" do
      ex = Exploder.new
      ex.source = [2,3]
      ex.to_enum.to_a.should == ["hi 2", "hi 2", "hi 3", "hi 3", "hi 3"]
    end
  end

  context "nill source" do
    class MySomething < PiecePipe::Step
    end

    it "raises an error" do
      e = MySomething.new
      e.source = nil
      lambda do e.to_enum.to_a end.should raise_error(/source.*MySomething.*is nil/)
    end
  end

end
