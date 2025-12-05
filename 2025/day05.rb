input = File.read('day05.txt').split("\n\n")
ranges = input.first.split.map { |str| str.split('-') }.map { |a, b| a.to_i..b.to_i }.sort_by(&:first)

# part 1
puts input.last.split.map(&:to_i).count { |i| ranges.any? { |r| r.cover?(i) } }

i = 0

loop do
  break if i == ranges.length - 1

  r1 = ranges[i]
  r2 = ranges[i + 1]

  next i += 1 unless r1.overlap?(r2)

  last = [r1.last, r2.last].max
  ranges.delete_at(i)
  ranges[i] = r1.first..last
end

# part 2
puts ranges.sum(&:size)
