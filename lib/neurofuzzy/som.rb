module Neurofuzzy
  class Som
    attr_reader :lattice
    def initialize(layer_width, iterations, input_size)
      @d0t_factor = 0.5
      @d0t = layer_width * @d0t_factor
      @a0t = 0.1
      @iterations = iterations
      @lambda = @iterations / Math::log(@d0t)
      @vector_size = input_size
      @lattice = (1..layer_width).map {|x| (1..layer_width).map {|y| (1..input_size).map {|z| rand}}}
    end

    def clusterify(data)
      (0..@iterations-1).each do |t|
        ds = data.sample
        bmux, bmuy = find_bmu ds
        nr = neighborhood_radius t
        lr = learning_rate t
        transverse do |x, y|
          dist = distance bmux, bmuy, x, y
          next if dist > nr
          influence = neighborhood_function dist, nr
          @lattice[x][y].size.times do |i|
            @lattice[x][y][i] += (influence * lr) * (ds[i] - @lattice[x][y][i])
          end
        end
      end
    end

    def find_bmu(sample)
      min_dist = 1 << 28
      wx, wy = [0, 0]
      transverse do |x, y|
        dist = [sample, @lattice[x][y]].transpose.map {|a, b| (a - b)**2}.reduce :+
        wx, wy, min_dist = x, y, dist if dist < min_dist
      end
      [wx, wy]
    end

    private

    def neighborhood_function(dist, nr)
      Math::exp(- dist**2 / (2 * nr))
    end

    def distance(x1, y1, x2, y2)
      hex_distance(x1 - y1 / 2, y1, x2 - y2 / 2, y2)
    end

    def hex_distance(x1, y1, x2, y2)
      if x1 > x2
        hex_distance(x2, y2, x1, y1)
      else
        y2 >= y1 ? x2 - x1 + y2 - y1 : [x2 - x1, y1 - y2].max
      end
    end

    def transverse
      @lattice.size.times do |x|
        @lattice[x].size.times do |y|
          yield x, y
        end
      end
    end

    def learning_rate(t)
      @a0t * Math::exp(-t / @lambda)
    end

    def neighborhood_radius(t)
      @d0t * Math::exp(-t / @lambda)
    end
  end
end