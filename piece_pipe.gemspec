# -*- encoding: utf-8 -*-
require File.expand_path('../lib/piece_pipe/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Crosby", "Shawn Anderson"]
  gem.email         = ["crosby@atomicobject.com", "shawn42@gmail.com"]
  gem.description   = %q{PiecePipe is about breaking your problem into its smallest, most interesting pieces, solving those pieces and not spending time on the glue code between them. }
  gem.summary       = %q{ PiecePipe helps you break your code into small interesting pieces and provides the glue for pipelining them together to provide elegant, readable code. }
  gem.homepage      = "http://atomicobject.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "piece_pipe"
  gem.require_paths = ["lib"]
  gem.version       = PiecePipe::VERSION
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "pry"
    
end
