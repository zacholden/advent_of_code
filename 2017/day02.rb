input = File.read("day02.txt").split("\n").map { |row| row.split("\t").map(&:to_i) }

# part 1

puts input.reduce(0) { |acc, row| acc + (row.max - row.min) }

puts input.reduce(0) { |acc, row|
  sorted = row.sort.reverse

  index = 0
  left = 0
  right = 0

  loop do
    left = sorted[index]

    right = row.find { |right| left != right && (left % right).zero? }

    break if right

    index += 1
  end

  acc + left / right
}
