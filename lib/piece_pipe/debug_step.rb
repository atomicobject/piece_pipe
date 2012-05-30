module PiecePipe
  class DebugStep < PipelineElement
    def initialize(opts={},&block)
      @opts = opts
      @block = block
    end

    def process(item)
      title = @opts[:title] || "DEBUG:" 
      if @opts[:inspect_keys]
        puts "#{title} #{item.slice(*@opts[:inspect_keys])}"
      end
      @block.call if @block
      produce item
    end
  end
end
