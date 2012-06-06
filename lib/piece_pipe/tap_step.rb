module PiecePipe
  class TapStep < Step
    def initialize(&block)
      @block = block
    end

    def process(item)
      @block.call item
      produce item
    end
  end
end
