input = File.read("day09.txt").split.map { |str| str.split(',').map(&:to_i) }

result = input.product(input).filter_map do |a, b|
   next if a == b
   ((b.first - a.first).abs + 1) * ((b.last - a.last).abs + 1)
end.max

puts result
