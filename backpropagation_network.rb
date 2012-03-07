
class BackPropagationNetwork
	attr_accessor :max_error, :max_epochs
	attr_reader :learning_rate
	def initialize(input_size, output_size, *args)
		@layers = []
		sizes = [input_size] + args + [output_size] + [0]
		for i in (0..sizes.size-2)
			curr_layer_size, next_layer_size = sizes[i], sizes[i+1]
			if i == 0
				neurons = (1..curr_layer_size).map {InputNeuron.new(next_layer_size)}
				neurons.push BiasNeuron.new(next_layer_size)
			elsif i == sizes.size - 2
				neurons = (1..curr_layer_size).map {OutputNeuron.new(next_layer_size)}
			else
				neurons = (1..curr_layer_size).map {Neuron.new(next_layer_size)}
				neurons.push BiasNeuron.new(next_layer_size)
			end
			@layers.push(neurons)
		end
	end
	
	def learning_rate=(lr)
		@learning_rate = lr
		@layers.each {|layer| layer.each {|neuron| neuron.learning_rate = lr}}
	end
	
	def train(ps, es)
		@max_epochs.times do
			epoch_error = 0
			ps.zip(es).each do |p, e|
				y = classify p
				d = [e, y].transpose.map {|x| x.reduce :-}
				backpropagate d
				epoch_error += d.map {|err| err**2}.reduce :+
			end
			break if epoch_error / es.size < @max_error
		end
	end
	
	def classify(pattern)
		pattern.zip(@layers[0]).each {|p| p[1].input = p[0]}
		for i in (1..@layers.size-1)
			prev, curr = @layers[i-1], @layers[i]
			curr_layer_input = @layers.last == curr ? curr.size-1 : curr.size-2 # Bias extra neuron
			for j in (0..curr_layer_input)
				curr[j].input = (0..prev.size-1).map {|k| prev[k].fire(j)}
			end
		end
		@layers[@layers.size-1].map {|n| n.fire(0)}
	end
	
	private
	
	def backpropagate(d)
		d.zip(@layers[@layers.size-1]).each {|od, neuron| neuron.delta = od}
		(@layers.size-1).downto(1) do |i|
			curr, prev = @layers[i-1], @layers[i]
			curr_layer_output = @layers.last == prev ? curr.size-1 : curr.size-2 # Bias extra neuron
			for j in (0..curr_layer_output)
				curr[j].delta = (0..prev.size-1).map {|k| prev[k].delta}
			end
		end
	end
end

class Neuron
	attr_accessor :output, :learning_rate
	attr_reader :delta

	def initialize(next_layer_size)
		@output = Array.new next_layer_size 
		@weights = (1..next_layer_size).map {|v| rand * 2 - 1}
	end
	
	def fire(n)
		@output[n] = activation_function(@weights[n] * @input)
	end
	
	def input=(v)
		@input = v.reduce :+
	end
	
	def delta=(d)
		@delta = [d.take(@weights.size), @weights].transpose.map {|x| x.reduce :*}.reduce(:+)
		fix_weights
	end
	
	private
	
	def activation_function(t)
		1.0 / (1 + Math::exp(-t))
	end
	
	def activation_function_derivative(t)
		t * (1 - t)
	end
	
	def fix_weights
		@weights = @weights.map {|w| puts @learning_rate; w + @learning_rate * @delta * activation_function_derivative(w * @input) * @input}
	end
end

class InputNeuron < Neuron
	def input=(v)
		@input = v
	end
end

class OutputNeuron < Neuron
	def fire(n)
		@output[n] = activation_function(@input)
	end
	
	def delta=(d)
		@delta = d
		fix_weights
	end
end

class BiasNeuron < Neuron
	def initialize(next_layer_size)
		@weights = (1..next_layer_size).map {|v| rand * 2 - 1}
	end
	
	def fire(n)
		@weights[n]
	end
end
