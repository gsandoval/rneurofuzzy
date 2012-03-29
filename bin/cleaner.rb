#!/usr/bin/env ruby

hist = 0
range = 10
while line = gets
  line = line.chomp
  val = "#{line[16]}#{line[17]}".to_i
  if (val - range) <= 0 && (val - range)**2 < 100
    hist += 1
  else
    range = 0 if range == 60
    range += 10
    puts hist
    hist = 1
  end
end

puts hist