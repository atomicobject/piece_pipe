module PiecePipe
  # Essentially the same thing as MethodStep with AssemblyStep semantics.
  #
  # Because we don't have a clever way to determine that you might want to create
  # an assembly line out of wrapped methods, you need to use the conveneince method Pipeline#assembly_step, eg.
  #
  #   PiecePipe::Pipeline.new.assembly_step(:add_seatbelts)
  #
  # Currently only supports arity-1 methods: the parameter will be the inputs Hash,
  # the return is expected to be a Hash that will be produced via AssemblyStep#install.
  #
  # TODO; add support for arity-2 method wrapping to allow for zero-or-more #intall calls
  #
  class MethodAssemblyStep < AssemblyStep
    def initialize(meth)
      @method = meth
    end

    def receive(inputs)
      install(@method.call(inputs))
    end

  end
end
