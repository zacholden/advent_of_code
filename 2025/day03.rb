input = File.read("day03.txt").split.map { |str| str.split('').map(&:to_i) }

part1 = input.sum do |arr|
  first = arr[..-2].max
  first_index = arr.index(first)
  second = arr[(first_index + 1)..].max

  first * 10 + second
end

LENGTH = 12

def build_high_number(arr, result = [])
  return result.join.to_i if result.length == LENGTH

  max_in_bounds = arr.take(arr.length - LENGTH + 1 + result.length).max
  head = arr.shift
  result << head if head == max_in_bounds

  build_high_number(arr, result)
end

puts part1

part2 = input.sum do |arr|
  possible_starts = arr.take(arr.length - LENGTH + 1)
  first = possible_starts.max

  indexes = possible_starts.filter_map.with_index { |i, idx| i == first && idx}

  indexes.map { |index| build_high_number(arr.drop(index)) }.max
end

puts part2
