#!/usr/bin/env ruby

require 'backpropagation_network'

n = BackPropagationNetwork.new(0.2, 3, 1, 4, 2)
n.classify [0, 1, 0]
