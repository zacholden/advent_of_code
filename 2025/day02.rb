input = File
  .read("day02.txt")
  .split(",")
  .map { |str| str.split("-") }
  .map { |arr| Range.new(arr[0].to_i, arr[1].to_i) }

part1 = input.reduce(0) do |acc, range|
  acc + (range.filter do |int|
    arr = int.digits
    next unless arr.length.even?

    mid = arr.length / 2
    arr[..mid - 1] == arr[mid..]
  end).sum
end

puts part1

part2 = input.reduce(0) do |acc, range|
  acc + (range.filter do |int|
    arr = int.digits
    mid = arr.length / 2

    mid.downto(1).any? { |i| arr.each_slice(i).uniq.one? }
  end).sum
end

puts part2
