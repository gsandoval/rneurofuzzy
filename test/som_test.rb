#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require 'neurofuzzy'

som = Neurofuzzy::Som.new 2, 100000, 3
patterns = [
    [1, 1, 1], [-1, 1, 1], [1, 1, -1], [-1, 1, -1],
    [1, -1, 1], [-1, -1, 1], [1, -1, -1], [-1, -1, -1]
]
som.clusterify patterns
patterns.each do |p|
  puts som.find_bmu(p).inspect
end

