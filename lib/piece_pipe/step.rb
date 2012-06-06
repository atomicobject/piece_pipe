module PiecePipe
  class Step
    attr_accessor :source

    def to_enum
      Enumerator.new do |yielder|
        @yielder = yielder
        begin
          generate_sequence
        ensure
          @yielder = nil
        end
      end
    end

    protected 

    def generate_sequence
      if source.nil?
        raise "The source of Step #{self.class.name} is nil"
      end
      source.to_enum.each do |item|
        process(item)
      end
    end

    def process(item)
      produce item
    end

    def produce(something)
      @yielder << something
    end
  end
end
