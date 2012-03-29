#!/usr/bin/env ruby
#$LOAD_PATH << './'
require_relative 'kmeans'

data = []
real_class = []
while line = gets
  toks = line.chomp.split("\t")
  real_class.push toks[0].chomp
  d = []
  #(1..toks.size-1).each {|i| d.push Float(toks[i].chomp)}
  (1..3).each {|i| d.push Float(toks[i].chomp)}
  data.push d
end

#data = [[20, 10], [30, 40], [10, 20], [50, 70], [30, 10], [90, 40], [50, 60]]

k = Neurofuzzy::KMeans.new(5)
clusters = k.clusterify data
puts [clusters, real_class].transpose.inspect
