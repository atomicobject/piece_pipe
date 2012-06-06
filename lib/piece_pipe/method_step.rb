module PiecePipe
  class MethodStep < Step
    def initialize(meth)
      raise "method cannot be nil" if meth.nil?
      raise "method must accept 1 or 2 arguments; it accepts #{meth.arity}" if meth.arity != 1 and meth.arity != 2
      @method = meth
    end

    public :produce # We will provide a ref to self as a producer for use by @method.

    def process(item)
      case @method.arity
      when 1
        # The method takes 1 argument, which we assume to be the input item.
        # We also assume that the method RETURNS the ONLY item it wishes to produce.
        # Will always produce exactly 1 output, even if that's just nil.
        produce @method.call(item)
      when 2
        # The method takes 2 arguments.  Assume first is input item, second is "producer",
        # ie, a means for the method to produce 0, 1 or many outputs at its discretion.
        # (by calling producer.produce)
        # Return value of @method.call is NOT considered.
        @method.call item, self
      end
    end
  end
end
