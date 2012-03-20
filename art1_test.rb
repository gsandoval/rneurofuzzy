#!/usr/bin/env ruby

require_relative 'art1'

n = Neurofuzzy::Art1.new(3, 3, 0.3)
puts n.classify([0.0, 0.0, 1.0])
puts n.classify([0.0, 1.0, 0.0])
puts n.classify([0.0, 1.0, 1.0])
puts n.classify([1.0, 0.0, 0.0])
puts n.classify([1.0, 0.0, 1.0])
puts n.classify([1.0, 1.0, 0.0])
puts n.classify([1.0, 1.0, 1.0])

