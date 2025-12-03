input = File.read("day03.txt").split.map { |str| str.split('').map(&:to_i) }

def find_high_number(arr, length)
  return 0 if length.zero?

  max = arr[..-length].max
  index = arr.index(max) + 1

  max * 10**(length-1) + find_high_number(arr[index..], length - 1)
end

puts input.sum { |arr| find_high_number(arr, 2) }

puts input.sum { |arr| find_high_number(arr, 12) }
