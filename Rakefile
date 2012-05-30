#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
desc "Run all rspecs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '-c'
end

task :default => :spec

