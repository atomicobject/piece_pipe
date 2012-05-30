require 'spec_helper'

describe PiecePipe::Pipeline do
  class OneTwoThree < PiecePipe::PipelineElement
    def generate_sequence
      produce 1
      produce 2
      produce 3
    end
  end

  class TheDoubler < PiecePipe::PipelineElement
    def process(item)
      produce item * 2
    end
  end

  context "super simple" do
    it "produces the values of its source" do
      subject.step(OneTwoThree)
      subject.to_enum.to_a.should == [ 1, 2, 3]
    end
  end

  context "two steps" do
    it "produces transformed values by processing both steps for each item" do
      subject.
        step(OneTwoThree).
        step(TheDoubler)

      subject.to_enum.to_a.should == [ 2, 4, 6]
    end
  end

  context "using instantiated PipelineElements as steps" do
    it "produces transformed values by processing both steps for each item" do
      subject.
        step(OneTwoThree.new).
        step(TheDoubler.new)

      subject.to_enum.to_a.should == [ 2, 4, 6]
    end
  end

  context "using an enumerable object as the pipeline source" do
    it "works with Arrays" do
      subject.
        source([10,20,30]).
        step(TheDoubler)
      subject.to_enum.to_a.should == [20, 40, 60]
    end

    it "works with PipelineElements" do
      subject.
        source(OneTwoThree.new).
        step(TheDoubler)
      subject.to_enum.to_a.should == [2, 4, 6]
    end

    it "raises if there's already something set as a source" do
      subject.source([10,20,30])
      lambda do subject.source([1,2,3]) end.should raise_error(/source already set/i)
    end

    it "raises if there's already a step" do
      subject.step(OneTwoThree)
      lambda do subject.source([1,2,3]) end.should raise_error(/source already set/i)
    end
  end

  describe "#collect" do
    let(:project_info) {
      [
        {name: "Project 1", project_health_summary: "Summary 1"},
        {name: "Project 2", project_health_summary: "Summary 2"},
      ]
    }

    it "maps the pipeline items down to the values indicated by the given key" do
      subject.
        source(project_info).
        collect(:project_health_summary)
      subject.to_enum.to_a.should == [
        "Summary 1",
        "Summary 2"
      ]
    end
  end

end
