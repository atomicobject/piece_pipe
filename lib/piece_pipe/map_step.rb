module PiecePipe
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
