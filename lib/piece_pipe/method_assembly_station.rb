module PiecePipe
  class MethodAssemblyStation < AssemblyStation
    def initialize(meth)
      @method = meth
    end

    def receive(inputs)
      install(@method.call(inputs))
    end

  end
end
