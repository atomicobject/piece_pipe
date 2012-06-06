module PiecePipe
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

    def aggregate(key, values)
      produce key: key, values: values 
    end
  end
end
    
