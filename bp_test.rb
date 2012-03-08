#!/usr/bin/env ruby

require 'backpropagation_network'

n = BackPropagationNetwork.new(2, 1, 3, 2)
n.learning_rate = 0.5
n.max_error = 0.0001
n.max_epochs = 1

patterns = [[0, 0], [1, 0], [0, 1], [1, 1]]
expected = [[0], [1], [1], [0]]
n.train patterns, expected
#puts n.classify [0, 1, 0]
