module PiecePipe
  # MethodStep makes it possible to define a pipeline step by wrapping a Method
  # object. Eg,
  #   PiecePipe::Pipeline.new.step( method(:do_something) )
  #
  # In this contrived example, whatever class is building the Pipeline has
  # a #do_something method, which is accessed as a Method object from Ruby's
  # reflection API via Kernel#method.
  #
  # If the wrapped method accepts a single parameter (arity 1), the inputs
  # to your MethodStep will be passed in via this parameter, and the return
  # value of your method will be automatically #produced, even if you 
  # return nil.
  #
  # If the wrapped method accepts TWO parameters (arity 2), the inputs will
  # still arrive via the first paramter, and the second parameter will
  # be a "producer" object that responds to #produce.  This gives you the
  # flexibility to #produce zero-or-many items, as in normal Step 
  # subclasses.  In the case of arity-2 methods, the return value
  # is disregarded.  Failing to call producer#produce will result
  # in a filtering-out of objects.
  #
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
