module PiecePipe
  class Collector < PipelineElement
    def initialize(key)
      @key = key
    end

    def process(hash)
      produce hash[@key]
    end
  end
end
