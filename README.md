# PiecePipe

PiecePipe is about breaking your problem into its smallest, most interesting pieces, solving those pieces and not spending time on the glue code between them.

## Motivation

Though this style of programming is similar to sequence processing using map, select and inject, PiecePipe
gives us power to:

* Improve expressiveness -- our high-level pipeline definition reads like a book and encompasses a comprehensible algorithm.
* Address and test each of the interesting little steps.
* Decouple ourselves from the implementation of map, select etc, which assume you're processing a collection, and have preconceptions on how they should be iterated over.

For sufficiently interesting algorithms we often talk in circles about how to break the problem down such that
no one piece is too complicated, then glue it all together.  We end up with a tree of strangely named calculator
objects and an almost arbitrary sprinkling of looping/mapping constructs.  We got sick of trying to 
organize the glue and decided to see if we could just boil it down to "what are the interesting operations, 
and what are the smallest pieces we can operate on?"

## Installation

Add this line to your application's Gemfile:

    gem 'piece_pipe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install piece_pipe

## Usage

```ruby
class NuclearPowerPlantHealthSummaryGenerator
  def generate(region)
    PiecePipe::Pipeline.new.
      source([{region: region}]).
      step(FetchPowerPlantsByRegion).
      step(FindWorstReactor).
      step(DetermineStatusClass).
      step(BuildPlantHealthSummary).
      step(SortByRadiationLevelsDescending).
      collect(:plant_health_summary).
      to_enum
  end

  # Custom Step, overriding #generate_sequence to produce a sequence of power plants for a given region.
  # Each power plant is "produced" as a Hash with one key (so far) heading down the pipeline.
  class FetchPowerPlantsByRegion < PiecePipe::Step
    def generate_sequence(inputs)
      # The expected interface of any Step's soure is that it supports #to_enum.  
      source.to_enum.each do |inputs|
        inputs[:region].power_plants.those_still_open.each do |power_plant|
          produce power_plant: power_plant  # Each call to #produce sends another object down the pipe
        end
      end
    enb
  end

  # For any given power plant, determine the worst reactor.
  # Implemented as an AssemblyStep that analyzes inputs[:power_plant] from the prior Step,
  # and installs a new key/val pair for :worst_reactor.  
  class FindWorstReactor < PiecePipe::AssemblyStep
    def receive(inputs)
      # Figure out which reactor has the highest radiation levels.
      # "install" works a lot like "produce", but rather than take responsibility for the totality
      # of the produced object, we're just saying "add :worst_reactor to whatever's there and pass it on".
      install worst_reactor: inputs[:power_plant].reactors.reject(&:offline?).max_by(:&radiation)
    end
  end

  # Figure out which CSS class corresonds to the radiation from the worst reactor.
  # (At this point, the inputs Hash has keys :region, :power_plant,  and :worst_reactor.)
  class DetermineStatusClass < PiecePipe::AssemblyStep
    def receive(inputs)
      install highlight_css_class: StatusFormatters.determine_css_class(inputs[:worst_reactor].radiation)
    end
  end

  # Composite our details into a line-item structure for our report.
  # Even though we consume most of the interesting values that arrive in the inputs Hash,
  # we're letting them ride as we simply install one more key, :plant_health_summary.
  # (This comes in handy, as we intend to sort these structures in a later step, using values
  # that are present in our transient input Hash, but NOT actually available in the 
  # report structure.)
  class BuildPlantHealthSummary < PiecePipe::AssemblyStep
    def receive(inputs)
      power_plant = inputs[:power_plant]
      worst_reactor = inputs[:worst_reactor]
      install plant_health_summary: PlantHealthSummary.new(
        power_plant_id: power_plant.id,
        supervisor: power_plant.supervisor,
        reactor_name: worst_reactor.name,
        radiation: StatusFormatters.format_radiation(worst_reactor.radiation),
        css_class: inputs[:highlight_css_class]
      )
    end
  end

  # Sort all the values that come through the pipe based on the radiation of the worst reactor
  # in each power_plant.
  # Notice this is not an AssemblyStep, and we're overriding #generate_sequence again, this time
  # because we're implementing a sink.  The resulting downstream objects have the same structure
  # they arrived with.
  class SortByRadiationLevelsDescending < PiecePipe::Step
    def generate_sequence
      source.to_enum.sort_by do |inputs|
        inputs[:worst_reactor].radiation
      end.each do |inputs|
        produce inputs
      end
    end
  end

  #... and that's it. Recall that the pipeline terminates with .collect(:plant_health_summary), which
  # is shorthand for a special Step that accepts Hashes and uses #produce to spit out only the specified
  # objects.  Downstream of our #collect, only the PlantHealthSummary remains.

end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
