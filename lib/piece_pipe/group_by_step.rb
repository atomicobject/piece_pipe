module PiecePipe

  # does a map / aggregate for you
  class GroupByStep < Step
    def initialize(*keys)
      @hash = {}
      @keys = keys
    end

    def process(item)
      key = nil
      if @keys.size > 1
        key = []
        @keys.each do |k|
          key << item[k]
        end
      else
        key = item[@keys.first]
      end

      val = item
      @hash[key] ||= []
      @hash[key] << item
    end

    def generate_sequence
      super
      @hash.each do |key,values|
        produce key => values
      end
    end
  end

end
