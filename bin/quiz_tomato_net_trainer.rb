#!/usr/bin/env ruby
=begin
Last epoch error: 0.00185
Last epoch: 100K
=end
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "neurofuzzy"
require "chunky_png"
require_relative 'quiz_ocr_preprocessor'

patterns = []
expected = []
max, min = 0, 1<<28
while line = gets
  line = line.chomp
  next if line.size == 0
  tok = line.split
  p = []
  e = []
  tok.take(tok.size - 1).each {|c| p.push Float(c)}
  tok.drop(tok.size - 1).each {|c| e.push Float(c)}
  p.each do |c|
    max = c if c > max
    min = c if c < min
  end
  patterns.push p
  expected.push e
end
patterns = patterns.map {|v| v.map {|x| (x - min) / (max - min)}}

input_size = patterns.size > 0 ? patterns[0].size : 4

nn = Neurofuzzy::BackPropagationNetwork.new input_size, 1, 3
nn.max_epochs = 100000
nn.max_error = 0.001
nn.learning_rate = 0.05
nn.momentum = 0.1
weights = nn.train patterns, expected
puts weights.inspect