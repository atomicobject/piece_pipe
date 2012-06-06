module PiecePipe
  class Pipeline
    def initialize
      @latest_source = nil
    end

    def source(source)
      raise "Source already set to #{@latest_source.inspect}" unless @latest_source.nil?
      @latest_source = source
      self
    end

    def input(item)
      source [item]
      self
    end

    def step(step)
      case step
      when Class
        step = step.new # If the arg is a Class, instantiate it
      when Method
        step = MethodStep.new(step)
      end
      add_step step
    end

    def assembly_step(step)
      case step
      when Class
        step = step.new # If the arg is a Class, instantiate it
      when Method
        step = MethodAssemblyStep.new(step)
      end
      add_step step
    end

    def add_step(step)
      step.source = @latest_source
      @latest_source = step
      self
    end
    private :add_step

    def tap(&block)
      step(TapStep.new(&block))
    end

    def debug(opts)
      step(DebugStep.new(opts))
    end

    def collect(key)
      step(Collector.new(key))
    end

    def result
      to_enum.first
    end

    def to_enum
      @latest_source.to_enum
    end
    alias smoke to_enum

    def to_a
      to_enum.to_a
    end
  end

  def create_pipeline
    ::Pipeline::Pipeline.new
  end

end
