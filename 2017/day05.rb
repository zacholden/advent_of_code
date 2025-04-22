input = File.read("day05.txt").split("\n").map(&:to_i).freeze

arr = input.dup
index = 0
steps = 0

loop do
  break puts steps if index.negative? || index >= arr.length

  jump = arr[index]
  arr[index] += 1

  index += jump
  steps += 1
end

arr = input.dup
index = 0
steps = 0

loop do
  break puts steps if index.negative? || index >= arr.length

  jump = arr[index]
  jump >= 3 ? arr[index] -= 1 : arr[index] += 1

  index += jump
  steps += 1
end
