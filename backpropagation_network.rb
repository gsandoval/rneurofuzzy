
class Neuron
	attr_accessor :output, :weights, :bias
	
	def initialize()
		
	end
end

class BackPropagationNetwork
	def initialize(learning_rate, input_size, output_size, *args)
		@lr = learning_rate
		layer_sizes = []
		layer_sizes.push input_size
		args.each {|s| layer_sizes.push s}
		layer_sizes.push output_size
		
		#rand * 2 - 1
		@layers = []
		@layers.push
	end
	
	def classify(pattern)
		@layers[0].zip(pattern).each {|p| p[0].output = p[1]}
		
	end
end
