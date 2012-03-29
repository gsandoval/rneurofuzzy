#!/usr/bin/env jruby
=begin
../../fonts/01.png -> [1, 1]
../../fonts/02.png -> [0, 0]
../../fonts/03.png -> [1, 0]
../../fonts/04.png -> [0, 2]
../../fonts/05.png -> [2, 2]
../../fonts/06.png -> [0, 2]
../../fonts/07.png -> [1, 2]
../../fonts/08.png -> [2, 2]
../../fonts/09.png -> [2, 1]
../../fonts/10.png -> [2, 1]
=end
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require 'neurofuzzy'
require 'chunky_png'

som = Neurofuzzy::Som.new 3, 10000, 7

files = Dir.glob("#{ARGV[0]}*.png")

im = Neurofuzzy::ImageMoments.new

patterns = []
max = 0
for file in files
  curr = files.index file
  raw_image = ChunkyPNG::Image.from_file(file)
  img_h = raw_image.dimension.height
  img = Array.new(3, Array.new(img_h))
  img_h.times do |j|
    img[0][j], img[1][j], img[2][j] = raw_image.row(j).map {|c| [c >> 24 & 0xFF, c >> 16 & 0xFF, c >> 8 & 0xFF]}.transpose
  end
  hu_moments = im.hu_invariant_moments img[0]

  hu_moments.each {|hm| max = hm if hm > max}
  patterns.push hu_moments
end

patterns = patterns.map {|v| v.map {|c| c * 1.0 / max}}
som.clusterify patterns

patterns.zip(files).each {|p, f| puts "#{f} -> #{som.find_bmu(p).inspect}"}

