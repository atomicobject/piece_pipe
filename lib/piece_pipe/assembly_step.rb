
module PiecePipe
  class AssemblyStep < Step
    def process(item)
      ensure_hash_like_object item
      @assembly = item
      begin
        receive(item)
      ensure
        @assembly = nil
      end
    end

    def receive(assembly)
      noop
    end

    def noop
      install({})
    end

    def install(value,opts={})
      output = @assembly.merge(value || {})
      
      if opts[:drop]
        opts[:drop].each do |key|
          output.delete(key)
        end
      end
      produce output
    end

    private
    def ensure_hash_like_object(obj)
      unless obj.respond_to?(:[]) and obj.respond_to?(:merge) and obj.respond_to?(:dup)
        raise "AssemblyStep object #{self.class.name} requires its source to produce Hash-like elements; not acceptable: #{obj.inspect}"
      end
    end
  end
end
