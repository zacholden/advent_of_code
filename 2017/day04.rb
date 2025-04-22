input = File.read("day04.txt").split("\n")

require 'set'

# part 1
puts input.count { |row| row.split.tally.values.max == 1 }

# part 2
puts input.count { |row| row.split.map { |str| Set.new(str.split("")) }.tally.values.max == 1 }
