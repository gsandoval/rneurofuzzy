#!/usr/bin/env ruby
=begin
Last epoch error: 0.0036
Last epoch: 17543
=end
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "chunky_png"
require "neurofuzzy"
require_relative 'quiz_ocr_preprocessor'

files = Dir.glob("#{ARGV[0]}*.png")

#mapping = "abcdefghijklmnopqrstuvwxyz"
mapping = "aeiou"
pattern = []
expected = []

max = 0
min = 1 << 28
for file in files
  curr = files.index file
  print "Preprocessing %d%%: %s\r" % [curr * 100.0 / (files.size - 1), file]
  ind = file.index "upper_"
  pattern_class = file[ind + 6]
  next if mapping.index(pattern_class).nil?
  #mapped_output = [mapping.index(pattern_class) * 1.0 / mapping.size]
  mapped_output = mapping.chars.to_a.map {|c| c == pattern_class ? 1 : 0}
  expected.push mapped_output

  raw_image = ChunkyPNG::Image.from_file(file)

  extr = QuizOcrPreprocessor.new
  img = extr.process raw_image

  p = []
  img.each {|v| v.each{|cc| p.push cc * 1.0 / 255}}
  pattern.push p
=begin
  invmoments = Neurofuzzy::ImageMoments.new
  hu_moments = invmoments.hu_invariant_moments img
  min = hu_moments.min if min > hu_moments.min
  max = hu_moments.max if max < hu_moments.max
  pattern.push hu_moments
=end
end
puts

#pattern = pattern.map {|p| p.take(7).map {|c| (c - min) / (max - min)}}
input_size = pattern.size > 0 ? pattern[0].size : 15*15

nn = Neurofuzzy::BackPropagationNetwork.new(input_size, 5, 40)
nn.max_epochs = 100000
nn.max_error = 0.001
nn.learning_rate = 0.01
nn.momentum = 0.1
weights = nn.train pattern, expected
puts weights.inspect




