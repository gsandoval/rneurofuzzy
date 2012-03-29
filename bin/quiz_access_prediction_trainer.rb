#!/usr/bin/env jruby
=begin
Last epoch error: 29.9996
Last epoch: 189
=end
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "neurofuzzy"

raw_data = []
max = 0
while line = gets
  line = line.chomp
  c = Integer(line)
  max = c if c > max
  raw_data.push c
end
for i in (0..raw_data.size-1)
  raw_data[i] /= (max * 1.0)
end

input_size = 10
nn = Neurofuzzy::BackPropagationNetwork.new input_size, 1, 7
nn.max_epochs = 100000
nn.max_error = 30.0
nn.learning_rate = 0.3
nn.momentum = 0.5

patterns = []
expected = []
for i in (0..raw_data.size-input_size-1)
  patterns.push(raw_data.drop(i).take(input_size))
  expected.push(raw_data.drop(i + input_size).take(1))
end

weights = nn.train patterns, expected
puts weights.inspect