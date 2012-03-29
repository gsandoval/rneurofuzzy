#!/usr/bin/env ruby
=begin
Last epoch error: 0.0009
Last epoch: ~20k
=end
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "neurofuzzy"

patterns = [
    [1, 1, 1], [-1, 1, 1], [1, 1, -1], [-1, 1, -1],
    [1, -1, 1], [-1, -1, 1], [1, -1, -1], [-1, -1, -1]
]

expected = [
    [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1],
    [0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]
]

nn = Neurofuzzy::BackPropagationNetwork.new(3, 4, 5)
nn.max_epochs = 100000
nn.max_error = 0.001
nn.learning_rate = 0.3
nn.momentum = 0.5
weights = nn.train patterns, expected
puts weights.inspect
