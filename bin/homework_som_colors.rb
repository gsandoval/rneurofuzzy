#!/usr/bin/env jruby
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')
require 'neurofuzzy'
require 'chunky_png'

patterns = [
    [1, 0, 0], [0, 1, 0], [0, 0, 1], [1, 1, 0], [1, 0, 1], [0, 1, 1], [1, 1, 1]
]

lattice_width = 40

som = Neurofuzzy::Som.new lattice_width, 5000, 3
som.clusterify patterns

lat = som.lattice
colors = lat.map {|v| v.map {|vv| vv.map {|c| (c * 255).round}}}
canvas = ChunkyPNG::Canvas.new lattice_width, lattice_width
colors.size.times do |x|
  colors[x].size.times do |y|
    cc = (colors[x][y][0] << 24) + (colors[x][y][1] << 16) + (colors[x][y][2] << 8) + 255
    canvas.set_pixel x, y, cc
  end
end
img = ChunkyPNG::Image.from_canvas(canvas)
img.save "colors.png"
