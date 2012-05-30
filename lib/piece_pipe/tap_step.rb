module PiecePipe
  class TapStep < PipelineElement
    def initialize(&block)
      @block = block
    end

    def process(item)
      @block.call item
      produce item
    end
  end
end
