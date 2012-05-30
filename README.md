# PiecePipe

PiecePipe is about breaking your problem into its smallest, most interesting pieces, solving those pieces and not spending time on the glue code between them.

## Installation

Add this line to your application's Gemfile:

    gem 'piece_pipe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install piece_pipe

## Usage

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
end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
