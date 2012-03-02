
class Neuron
	attr_accessor :output

	def initialize(next_layer_size)
		@output = Array.new next_layer_size 
		@weights, @bias = [], []
		(1..next_layer_size).each do
			@weights.push rand * 2 - 1
			@bias.push rand * 2 - 1
		end
	end
	
	def activation_function(t)
		1.0 / (1 + Math::exp(-t))
	end
	
	def fire(n)
		@output[n] = @forced ? @forced[n] : activation_function(@weights[n] * @input + @bias[n])
	end
	
	def input(v)
		@input = v.reduce :+
	end
	
	def force_output(forced_output)
		@forced = forced_output
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
	
	def train(ps)
		
	end
	
	def classify(pattern)
		@layers[0].zip(pattern).each {|p| p[0].force_output [p[1]] * @layers[1].size}
		for i in (1..@layers.size-1)
			prev, curr = @layers[i-1], @layers[i]
			for j in (0..curr.size-1)
				v = []
				for k in (0..prev.size-1)
					v.push(prev[k].fire(j))
				end
				curr[j].input v
			end
		end
	end
end
