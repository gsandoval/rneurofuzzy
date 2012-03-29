#!/usr/bin/env ruby
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
nn.trained_weights = [[12.199050733273774, -17.613846783341266, 6.16728901957925, -99.45590387214733, 71.03173792244978], [-0.15656460190202323, 3.4015771808190385, 1.0791067429845724, 6.621722466940504, -1.4236152597208254], [-2.217415142841846, 5.571446925383219, 1.2597271179136282, 10.134691932497159, -4.020700140127107], [33.7853780501437, 41.59702477455833, 32.996558534034556, 42.858402776326514, 35.658278781666326], [31.13478857141749, -3.714258107007977, -7.226677375277358, -3.5388962737014498]]

patterns.each do |p|
  puts nn.classify(p)[0].round
end