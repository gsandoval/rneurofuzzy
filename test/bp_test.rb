#!/usr/bin/env ruby

require_relative 'backpropagation_network'

n = Neurofuzzy::BackPropagationNetwork.new(2, 1, 3)
n.learning_rate = 0.7
n.momentum = 0.3
n.max_error = 0.0001
n.max_epochs = 50000

patterns = [[0, 0], [1, 0], [0, 1], [1, 1]]
expected = [[0.00001], [1], [1], [0.00001]]
trained_weights = n.train patterns, expected

puts
puts trained_weights.inspect
puts

n.trained_weights = [[-23.0217773437391, -22.8139049001462, 32.6026950655199],
[21.4243407311869, -32.9338898394372, 5.47305730031733],
[-33.3855565563251, 22.9474149772918, 4.40321880916154],
[-0.853068673429263, 0.955086312185503, -35.5191444793863],
[-7.02187697749253, 10.0851640847795, 10.0165774181415, -6.34209667187675]]


puts n.classify([0, 0]).inspect
puts n.classify([0, 1]).inspect
puts n.classify([1, 0]).inspect
puts n.classify([1, 1]).inspect
