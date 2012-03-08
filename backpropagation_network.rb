
class BackPropagationNetwork
	attr_accessor :max_error, :max_epochs
	attr_reader :learning_rate, :momentum
	def initialize(input_size, output_size, *args)
		@input_layer = (0..input_size).map {|i| Neuron.new(1)}
		@input_layer.last.raw_input = 1 # Bias
		prev_size = input_size
		@hidden_layers = []
		for size in args
			@hidden_layers.push((0..size).map {|i| Neuron.new(prev_size + 1)})
			@hidden_layers.each {|lyr| lyr.last.raw_input = 1} # Bias
			prev_size = size
		end
		@output_layer = (1..output_size).map {|i| Neuron.new(prev_size + 1)}
	end
	
	def trained_weights=(tw)
		nn = []
		@hidden_layers.each {|layer| layer.each {|neuron| nn.push neuron}}
		@output_layer.each {|neuron| nn.push neuron}
		nn.zip(tw).each {|n, w| n.weights = w}
	end
	
	def learning_rate=(lr)
		@learning_rate = lr
		@hidden_layers.each {|layer| layer.each {|neuron| neuron.learning_rate = lr}}
		@output_layer.each {|neuron| neuron.learning_rate = lr}
	end
	
	def momentum=(m)
		@momentum = m
		@hidden_layers.each {|layer| layer.each {|neuron| neuron.momentum = m}}
		@output_layer.each {|neuron| neuron.momentum = m}
	end
	
	def train(ps, es)
		epoch_error = 0
		@max_epochs.times do |epoch|
			epoch_error = 0
			ps.zip(es).each do |p, e|
				y = classify p
				e = e.map {|x| x == 0 ? 0.00000000001 : (x == 1 ? 0.999999999999 : x)}
				err = [y, e].transpose.map {|x| x.reduce :-}
				backpropagate err
				epoch_error += err.map {|e| e**2}.reduce :+
			end
			break if epoch_error.nan?
			#epoch_error = Math::sqrt(epoch_error / es.size)
			epoch_error /= 2.0
			
			#if epoch % 1000 == 0
			#	puts "epoch: #{epoch}, epoch error: #{epoch_error}"
			#	ps.zip(es).each do |p, e|
			#		y = classify p
			#		puts "#{p.inspect} -> #{y.inspect}"
			#	end
			#end
			puts "epoch #{epoch}: #{epoch_error}"
			
			break if epoch_error < @max_error
		end
		puts "Final epoch error: #{epoch_error}"
		trained_weights = []
		@hidden_layers.each {|layer| layer.each {|neuron| trained_weights.push neuron.weights}}
		@output_layer.each {|neuron| trained_weights.push neuron.weights}
		trained_weights
	end
	
	def classify(pattern)
		pattern.zip(@input_layer).each {|p| p[1].raw_input = p[0]}
		inp = @input_layer.map {|n| n.output}
		@hidden_layers.each do |layer|
			layer[0..layer.size-2].each {|n| n.input = inp}
			inp = layer.map {|n| n.output}
		end
		@output_layer.each {|n| n.input = inp}
		@output_layer.map {|n| n.output}
	end
	
	private
	
	def backpropagate(err)
		err.zip(@output_layer).each {|e, neuron| neuron.delta = [e]}
		prev_layer = @output_layer
		@hidden_layers.reverse.each do |curr|
			for i in (0..curr.size-1)
				curr[i].delta = (0..prev_layer.size-1).map {|j| prev_layer[j].delta(i)}
			end
			prev_layer = curr
		end
		prev_layer = @input_layer
		@hidden_layers.each do |layer|
			layer.each {|neuron| neuron.adjust_weights prev_layer.map{|n| n.output}}
			prev_layer = layer
		end
		@output_layer.each {|neuron| neuron.adjust_weights prev_layer.map{|n| n.output}}
	end
end

class Neuron
	attr_accessor :learning_rate, :momentum, :raw_input, :weights

	def initialize(prev_layer_size)
		@weights = (1..prev_layer_size).map {|v| rand * 2 - 1}
		@last_weight_update = Array.new(prev_layer_size, 0)
	end
	
	def input=(v)
		@raw_input = ([@weights, v].transpose.map {|x| x.reduce :*}).reduce :+
	end
	
	def output
		@output = activation_function(@raw_input)
	end
	
	def delta=(d)
		@delta = d.reduce :+
	end
	
	def delta(n)
		@delta * @weights[n]
	end
	
	def adjust_weights(prev_layer_input)
		@last_weight_update = @last_weight_update.zip(prev_layer_input).map {|lu, inp| -@learning_rate * @delta * activation_function_derivative(@raw_input) * inp + @momentum * lu}
		@weights = @weights.zip(@last_weight_update).map {|w, lu| w + lu}
	end
	
	private
	
	def activation_function(t)
		1.0 / (1 + Math::exp(-t))
	end
	
	def activation_function_derivative(t)
		fx = 1.0 / (1 + Math::exp(-t))
		fx * (1 - fx)
	end
end

