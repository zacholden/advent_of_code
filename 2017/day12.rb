require 'set'

input = File
  .read("day12.txt")
  .gsub(" <->", ",")
  .split("\n")
  .map do |str|
    str
      .split(", ")
      .map(&:to_i)
      .then { |arr| {arr.first => arr[1..]} }
  end
  .reduce(&:merge)

sets = []

loop do
  key = input.keys.first

  set = Set.new([key])
  queue = [key]

  loop do
    key = queue.shift

    if set.member?(key)
      vals = input.delete(key)
      next if vals.nil?

      vals.each { |v| set.add(v) }
      vals.each { |v| queue.push(v) }
    end

    break if queue.empty?
  end

  puts set.size if sets.empty?
  sets << set
  break if input.empty?
end

puts sets.size
