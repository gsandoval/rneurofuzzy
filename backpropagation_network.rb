
class Neuron
	attr_accessor :output, :weights, :bias
	
	def initialize(next_layer_size)
		output = Array.new(next_layer_size)
		weights, bias = [], []
		(1..next_layer_size).each do
			weights.push rand * 2 - 1
			bias.push rand * 2 - 1
		end
	end
	
	def fire
		
	end
end

class BackPropagationNetwork
	def initialize(learning_rate, input_size, output_size, *args)
		@lr = learning_rate
		@layers = []
		sizes = [input_size] + args + [output_size] + [0]
		for i in (0..sizes.size-2)
			@layers.push((1..sizes[i]).map {Neuron.new(sizes[i+1])})
		end
	end
	
	def classify(pattern)
		@layers[0].zip(pattern).each {|p| p[0].output = p[1]}
		for i in (1..@layers.size-1)
			prev, curr = @layers[i-1], @layers[i]
			for j in (0..curr.size-1)
				input = []
				for k in (0..prev.size-1)
					input.push(prev[k].output[j] * prev[k].weights[j])
				end
				curr[j].fire input
			end
		end
	end
end
