module Neurofuzzy
  class Som
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
        bmux, bmuy = find_bmu(ds)
      end
    end

    def find_bmu(sample)
      [0, 0]
    end
  end
end