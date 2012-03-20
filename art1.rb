module Neurofuzzy
  class Art1
    def initialize(input_size, cluster_count, ro)
      @cluster_count = cluster_count
      @input_size = input_size
      @buws = Array.new(cluster_count, Array.new(input_size, 1.0 / (1 + input_size)))
      @tdws = Array.new(cluster_count, Array.new(input_size, 1.0))
      @ro = ro
    end

    def classify(input)
      activation = @buws.map {|buw| [buw, input].transpose.map {|x| x.reduce :*}.reduce :+}
      k2 = -1
      tries = 0
      while true
        k2 = activation.index activation.max
        tries += 1
        reconstructed = [@tdws[k2], input].transpose.map {|x| x.reduce :*}

        input_sum = input.reduce :+
        reconstructed_sum = reconstructed.reduce :+
        if reconstructed_sum / input_sum >= @ro
          @buws[k2] = reconstructed.map {|a| a / (0.5 + reconstructed_sum)}
          @tdws[k2] = reconstructed
          break
        else
          activation[k2] = -1
          k2 = -1
          break if tries == activation.size
        end
      end
      k2
    end
  end
end