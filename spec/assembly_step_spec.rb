require "spec_helper"

describe PiecePipe::AssemblyStep do

  context "default AssemblyStep" do
    it "produces unaltered items from its source" do
      as = PiecePipe::AssemblyStep.new
      as.source = [
        {hello: "hippo"},
        {hello: "lion"}
      ]
      as.to_enum.to_a.should == [
        {hello: "hippo"},
        {hello: "lion"}
      ]

    end
  end

  context "a typical AssemblyStep" do
    class AnimalPhraser < PiecePipe::AssemblyStep
      def receive(inputs)
        install phrase: "There are #{inputs[:count]} #{inputs[:animal]}s"
      end
    end

    it "can install new information into the work stream based on inputs" do
      ap = AnimalPhraser.new
      ap.source = [
        { animal: "Hippo", count: 2 },
        { animal: "Bird", count: 5 },
      ]
      ap.to_enum.to_a.should == [
        { animal: "Hippo", count: 2, phrase: "There are 2 Hippos" },
        { animal: "Bird", count: 5, phrase: "There are 5 Birds" },
      ]
    end

    class Cuber < PiecePipe::AssemblyStep
      def receive(inputs)
        num = inputs[:num]
        install squared: num * num, cubed: num * num * num
      end
    end

    it "can install multiple keys per item" do
      ap = Cuber.new
      ap.source = [
        { num: 2 },
        { num: 5 },
      ]
      ap.to_enum.to_a.should == [
        { num: 2, squared: 4, cubed: 8 },
        { num: 5, squared: 25, cubed: 125 },
      ]
    end
  end

  context "a filtering AssemblyStep" do
    class HippoHater < PiecePipe::AssemblyStep
      def receive(inputs)
        unless inputs[:animal] == "Hippo"
          install phrase: "There are #{inputs[:count]} #{inputs[:animal]}s"
        end
      end
    end

    it "can remove elements from the work stream by NOT invoking #install for certain items" do
      hh = HippoHater.new
      hh.source = [
        { animal: "Hippo", count: 2 },
        { animal: "Bird", count: 5 },
        { animal: "Hippo", count: 4 },
        { animal: "Cow", count: 1 },
      ]
      hh.to_enum.to_a.should == [
        { animal: "Bird", count: 5, phrase: "There are 5 Birds" },
        { animal: "Cow", count: 1, phrase: "There are 1 Cows" },
      ]
    end
  end

  context "an exploding AssemblyStep" do
    class LionCrusher < PiecePipe::AssemblyStep
      def receive(inputs)
        if inputs[:animal] == "Hippo"
          inputs[:lion_count].times do 
            install injured_lion: true
          end
        end
      end
    end

    it "can insert new elements into the work stream by invoking #install more than once for a given input" do
      lc = LionCrusher.new
      lc.source = [
        { animal: "Hippo", lion_count: 3 }
      ]
      lc.to_enum.to_a.should == [
        { injured_lion: true, animal: "Hippo", lion_count: 3 },
        { injured_lion: true, animal: "Hippo", lion_count: 3 },
        { injured_lion: true, animal: "Hippo", lion_count: 3 },
      ]
    end
  end

  context "error and oddball cases" do
    context "source produces non-Hash inputs" do
      class MyOtherSomething < PiecePipe::AssemblyStep
      end

      it "raises an error indicating requisite input type" do
        as = MyOtherSomething.new
        as.source = [1,2,3]
        lambda do as.to_enum.to_a end.should raise_error(/AssemblyStep object MyOtherSomething.*Hash-like/)
      end
    end

    context "overridden receive() installs nil" do
      class NilInstaller < PiecePipe::AssemblyStep
        def receive(inputs)
          install nil
        end
      end
      it "does a no-op" do
        as = NilInstaller.new
        as.source = [
          {hello: "hippo"},
          {hello: "lion"}
        ]
        as.to_enum.to_a.should == [
          {hello: "hippo"},
          {hello: "lion"}
        ]
        end
    end

    context "using noop()" do
      class UseTheNoOp < PiecePipe::AssemblyStep
        def receive(inputs)
          noop
        end
      end
      it "does a no-op" do
        as = UseTheNoOp.new
        as.source = [
          {hello: "hippo"},
          {hello: "lion"}
        ]
        as.to_enum.to_a.should == [
          {hello: "hippo"},
          {hello: "lion"}
        ]
        end
    end

    context "overwriting keys that are already present in the inputs" # not sure what that might mean?

    context "accessing keys that are NOT present in the inputs" # BOOM of course.... do something more interesting?
  end
end

