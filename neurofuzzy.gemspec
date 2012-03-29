# -*- encoding: utf-8 -*-
require File.expand_path('../lib/neurofuzzy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Guillermo Sandoval"]
  gem.email         = %w[gsandoval@darchitect.org]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "neurofuzzy"
  gem.require_paths = %w[lib]
  gem.version       = Neurofuzzy::VERSION
end