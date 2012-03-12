require 'matrix'

module Neurofuzzy

  class PerceptronNetwork
    def initialize(*args)
      if args[0].kind_of? Array #The one thing I don't like from Ruby: no ctor overload
        weights = args[0]
        bias = args[1]
        @w = Matrix.rows weights
        @b = Matrix.column_vector bias
      else
        neurons = args[0]
        inputs = args[1]
        learning_rate = args.size > 2 ? args[2] : 0.4
        weights = (0..inputs-1).map {|i| (0..neurons-1).map {|j| rand * 2 - 1}}
        @w = Matrix.rows weights
        bias = (0..neurons-1).map {|i| rand * 2 - 1}
        @b = Matrix.column_vector bias
        @L = @l = learning_rate
      end
    end

    def train(samples, max_epochs = 100000, error = 1 * 10**-10)
      xs = samples.map {|s| s.map {|v| Matrix.column_vector v}}
      last_epoch = 0
      scalar_epoch_error = 0
      for epoch in (1..max_epochs)
        puts "#{epoch} err: #{scalar_epoch_error} and L=#{@l}" if epoch % 1000 == 0
        epoch_error = Matrix.column_vector Array.new(@b.row_size, 0)
        xs.each do |xd|
          x,d = xd
          y = _classify x
          e = d - y.transpose
          @w = @w + @l * x * e.transpose
          @b = @b + @l * e
          epoch_error += e.map {|c| c**2}
        end
        scalar_epoch_error = 0
        epoch_error.each {|e| scalar_epoch_error += e}
        break if scalar_epoch_error / 2.0 < error
        last_epoch = epoch
        @l = @L / epoch**Math.exp(-4)
      end
      [last_epoch, scalar_epoch_error]
    end

    def classify(v)
      x = Matrix.column_vector v
      y = _classify x
      y.transpose.column(0).to_a
    end

    def weights
      ws = Array.new(@w.row_size) {Array.new(@w.column_size)}
      @w.each_with_index {|v,i,j| ws[i][j] = v}
      ws
    end

    def bias
      bias = []
      @b.each {|v| bias.push v}
      bias
    end

    private

    def step_activation_function(x)
      x.map {|c| c >= 0 ? 1 : 0}
    end

    def _classify(x)
      step_activation_function(x.transpose * @w + @b.transpose)
    end
  end

end