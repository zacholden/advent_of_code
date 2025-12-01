layers = File.read("day13.txt").split("\n").map { |s| s.split(": ").map(&:to_i) }.to_h

score = layers.reduce(0) do |acc, (time, depth)|
  if (time % ((depth - 1) * 2)).zero?
    acc + time * depth
  else
    acc
  end
end

puts score
