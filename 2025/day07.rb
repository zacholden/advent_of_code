input = File.read('day07.txt').split("\n").map { it.split('') }
start_x = input.first.index('S')
start_y = 1

mutable = input.map(&:dup)
mutable[start_y][start_x] = '|'

y = start_y
splits = 0

loop do
  beams = mutable[y].filter_map.with_index { |i, idx| i == '|' && idx }

  beams.each do |x|
    if mutable[y + 1][x] == '^'
      splits += 1
      mutable[y + 1][x - 1] = '|'
      mutable[y + 1][x + 1] = '|'
    else
      mutable[y + 1][x] = '|'
    end
  end

  y += 1
  break if y == mutable.length - 1
end

puts splits

# part 2
# New approach: start from the bottom where every split is two realities and move upwards,
# every splitter is the value of the splitters below it or one if it has none. Tranpose a copy
# so we can 'look down' in row major order.
y = input.length - 2
cache = {}
columns = input.transpose

loop do
  input[y].each.with_index do |char, x|
    next unless char == '^'

    left = columns[x - 1][y..].index('^')
    right = columns[x + 1][y..].index('^')

    left_score = left.nil? ? 1 : cache[[y + left, x - 1]]
    right_score = right.nil? ? 1 : cache[[y + right, x + 1]]

    cache[[y, x]] = left_score + right_score
  end

  y -= 2

  break unless y.positive?
end

puts cache.values.max
