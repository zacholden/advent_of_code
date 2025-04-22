input = File.read("day01.txt").chomp.split("").map(&:to_i)
length = input.length

# part 1

index = 0
total = 0

loop do
  break if index == length
  a = input[index]
  b = input[index + 1]

  total += a if a == b

  index += 1
end

total += input.last if input.first == input.last

puts total

# part 2

index = 0
total = 0
half = length / 2

loop do
  break if index == half
  a = input[index]
  b = input[index + half]

  total += a if a == b

  index += 1
end

puts total * 2
