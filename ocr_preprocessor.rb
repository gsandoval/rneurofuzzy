
require 'chunky_png'

class OCRPreprocessor
  def initialize
    @red = 0
    @green = 1
    @blue = 2
  end
  def process(raw_image)
    #raw_image = raw_image.resample 15, 15
    img_w = raw_image.dimension.width
    img_h = raw_image.dimension.height

    img = Array.new(3, Array.new(img_h))
    img_h.times do |j|
      img[@red][j], img[@green][j], img[@blue][j] = raw_image.row(j).map {|c| [c >> 24 & 0xFF, c >> 16 & 0xFF, c >> 8 & 0xFF]}.transpose
    end

    img[@red]
  end
end
