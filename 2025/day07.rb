input = File.read("day07test.txt").split("\n").map { it.split('') }
start_x = input.first.index("S")
start_y = 1

mutable = input.map(&:dup)
mutable[start_y][start_x] = "|"

y = start_y
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
# this will never finish, I need to memoize
last_row = input.length - 1

stack = []
x = start_x
y = start_y
permutations = 0

loop do
  if y == last_row
    permutations += 1

    y, x = stack.pop
    break if y.nil?

    next
  end

  if input[y][x] == '^'
    stack << [y + 1, x + 1]
    x -= 1
  end

  y += 1
end

puts permutations
