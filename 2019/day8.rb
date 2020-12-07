class Day8
  def initialize
    @input = File.read('day8.txt')
  end

  def build_image(hortizontal, vertical)
    @input
      .split('')
      .map(&:to_i)
      .each_slice(hortizontal)
      .to_a
      .each_slice(vertical)
      .with_index.reduce({}) { |acc, (slice, index)| acc.merge({ "Layer #{index+1}" => slice }) }
  end
end

require 'pry'
layer = Day8.new.build_image(25, 6).min_by { |k,v| v.flatten.count(&:zero?) }
ones = layer.last.flatten.count { |i| i == 1 }
twos = layer.last.flatten.count { |i| i == 2 }
puts ones * twos

image = Day8.new.build_image(25, 6).reduce([]) { |acc, (k,v)| acc << v }.map(&:flatten)
top_layer = (0..149).map do |y|
  x = (0..99).find { |x| image[x][y] != 2 }
  image[x][y]
end.map(&:to_s).map do |str|
  if str == '1'
    "\e[31m#{str}\e[0m"
  else
    "\e[32m#{str}\e[0m"
  end
end.each_slice(25).to_a

top_layer.each { |row| puts row.join }
