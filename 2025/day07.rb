input = File.read("day07test.txt").split("\n").map { it.split('') }
x = input.first.index("S")
y = 0

mutable = input.map(&:dup)
mutable[y][x] = "|"

splits = 0

loop do
  beams = mutable[y].filter_map.with_index { |i, idx| i == "|" && idx }

  beams.each do |x|
    if mutable[y + 1][x] == "^"
      splits += 1
      mutable[y + 1][x - 1] = "|"
      mutable[y + 1][x + 1] = "|"
    else
      mutable[y + 1][x] = "|"
    end
  end

  y += 1
  break if y == mutable.length - 1
end

puts splits

# part 2
# this is very slow I think I need to memoize
