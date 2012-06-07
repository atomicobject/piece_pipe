module PiecePipe
  #
  # This Step acts like a sink: it will process ALL available inputs until the stream ends,
  # and THEN call #aggregrate multiple times to transform accumulated data and produce output.
  #
  # For every key-value pair that arrives as an input (see MapStep for generating key-value pairs),
  # an array of values is accumulated per key.
  #
  # When all inputs have been collected, #aggregate is called for each key that has been seen to-date.
  #
  # Your job is to implement #aggregate, perform some calculation on the key and its accumulated
  # values, and generate output via zero or more calls to #produce.
  #
  class HashedAggregator < Step
    def initialize
      @hash = {}
    end

    def generate_sequence
      super
      @hash.each do |key,values|
        aggregate key, values
      end
    end

    def process(item)
      raise "HashedAggregator requires inputs to be Hashes with :key and :value" unless item.keys.include?(:key) and item.keys.include?(:value)
      # TODO : check key/val keys in item
      #
      @hash[item[:key]] ||= []
      @hash[item[:key]] << item[:value]
    end

    # Accepts a key and an array of all values that have been collected for that key.
    # Default impl simply produces { :key => key, :value => values } (essentially a noop).
    def aggregate(key, values)
      produce key: key, values: values 
    end
  end
end
    
