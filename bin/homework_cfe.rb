#!/usr/bin/env jruby
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require "neurofuzzy"

n = Neurofuzzy::BackPropagationNetwork.new(10, 1, 10, 5)
n.learning_rate = 0.2
n.momentum = 0.3
n.max_error = 0.02
n.max_epochs = 50000

raw_data = []
max = 1
while line = gets
	raw_data.push Float(line.chomp)
	max = max < raw_data.last ? raw_data.last : max
end
raw_data = raw_data.map {|d| d / max}

# 145 per day
training_set_size = raw_data.size / 6 * 5
patterns = []
expected = []
for i in (0..training_set_size-12)
	chunk = raw_data.drop(i).take(11)
	patterns.push chunk.take(10)
	expected.push chunk.drop(10)
end

all_patterns = []
for i in (0..raw_data.size-11)
	all_patterns.push raw_data.drop(i).take(10)
end

#patterns = [[0, 0], [1, 0], [0, 1], [1, 1]]
#expected = [[0.00001], [1], [1], [0.00001]]
trained_weights = n.train patterns, expected

puts
puts trained_weights.inspect
puts

=begin
n.trained_weights = [[31.0403924653464, 12.6267507031573, -3.84118567961158, -20.9323337199882,
-44.5520618231219, 27.713132535199], [40.9145101350059, 17.5953727419113, -4.92546179417203,
-30.8788280576639, -58.2512627420201, 38.3473557237457], [-56.1629300562758, -21.373387212721,
12.1457204439782, 46.1062007934645, 80.0400189975803, -63.8551157340661], [-40.9035935072015,
-16.9160623426545, 5.4300294407496, 30.5177808319202, 57.2915464154844, -38.3088805019932],
[-140.993272672986, -156.643736401803, -171.348999208015, -186.588412900544, -203.875515044015,
-123.948973299099], [-0.110279157567275, 0.526673508537936, -8.91272772087152, -3.35006723241387,
-0.806592314633721], [-2.00654101997798, -1.00213110706048, 9.21022157463615, 9.02305291063856,
4.31624943512518], [-9.55417828036355, -11.928224933708, 6.65755934046255, 2.11745937906744,
-7.11788250852242], [-1.58443765483341, -2.21858204053805, 11.0670742403668, 7.89673850361845,
4.26921783338202], [-2.53010431089853, 2.05227330374454, 2.26973169175638, 0.165019133320111],
[2.33200563497284, -2.74443478777663, -2.11232610212083, 0.368695196397919], [-1.42685026520017,
6.83020367519288, 8.53556431710088, 2.98299786320941], [2.29841433595223, -2.15296752750305, 1.20087204092843]]
=end

all_patterns.each {|p| puts "#{n.classify(p)[0] * max}"}

