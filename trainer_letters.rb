#!/usr/bin/env jruby
require 'perceptron_network'

line = gets.chomp
pattern_w, pattern_h = line.split(" ").map { |c| Integer(c) }

max_w_value_str = "1" * pattern_w
max_w_value = Integer("0b#{max_w_value_str}") * 1.0
max_h_value_str = "1" * pattern_h
max_h_value = Integer("0b#{max_h_value_str}") * 1.0

patterns = {}
while letter = gets
	letter = letter.chomp
	patterns[letter] = [] if patterns[letter].nil?
	pattern_num = Integer(gets.chomp)
	for pn in (1..pattern_num)
		vert = []
		v = Array.new
		for i in (1..pattern_h)
			row = gets.chomp
			vert.push row
			#v.push Integer("0b#{row}") / max_w_value
			row.each_char {|c| v.push Integer(c)}
		end
		
		for i in (0..pattern_w-1)
			col = ""
			for j in (0..pattern_h-1)
				col << vert[j][i..i]
			end
			#v.push Integer("0b#{col}") / max_h_value
		end
		
		patterns[letter].push v
	end
end

symbols = patterns.keys
len = symbols.size
output_mapping = {}
training_dataset = []
symbols.each_index do |i|
	expected = Array.new(len) {|k| k == i ? 1 : 0}
	output_mapping[expected] = symbols[i]
	patterns[symbols[i]].each {|a| training_dataset.push [a, expected]}
end
characteristics_vector_size = patterns[symbols[0]][0].size

nn = PerceptronNetwork.new(len, characteristics_vector_size)
epochs, error = nn.train training_dataset

puts "#{epochs} epochs and #{error} of error"
puts "weights:"
puts nn.weights.inspect
puts "bias:"
puts nn.bias.inspect
puts "mapping:"
puts output_mapping.inspect

#training_dataset.each do |p|
#	output = nn.classify p[0]
#	puts "#{output_mapping[p[1]]}, #{p[1]} -> #{output}"
#end
