#!/usr/bin/env rake

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "neurofuzzy/version"

task :build do
  system "gem build neurofuzzy.gemspec"
end

task :release => :build do
  system "gem push neurofuzzy-#{Bunder::VERSION}"
end