module PiecePipe
  #
  # This type of Step is designed to produce key-value pairs in anticipation of
  # a following aggregation step (see HashedAggregator).
  #
  # Subclasses implement #map and can produce output via #emit(key, value).
  # Zero-or-more pairs may be generted per #map invocation.
  #
  # The output structure is in fact a Hash with two keys: :key and :value, eg
  #
  #   class CalorieCounter < PiecePipe::MapStep
  #     # Expects inputs to be a Hash with :person, :date and :calories.
  #     # Output will look like: { :key => ["Dave","2012-05-10"], :value => 6000 }
  #     def map(inputs)
  #       key = [inputs[:person], inputs[:date]]
  #       val = inputs[:calories]
  #       emit key, val
  #     end
  #   end
  # 
  class MapStep < Step
    def process(item)
      map item
    end

    def map(item)
      emit item, item
    end

    def emit(key, value)
      produce key: key, value: value
    end
  end
end
