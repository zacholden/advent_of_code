input = File.read('day06.txt').split("\n")

def solve(arr, operation) = operation == '+' ? arr.sum : arr.reduce(&:*)

# part 1
puts input.map(&:split).transpose.sum { solve(it[..-2].map(&:to_i), it.last) }

# part 2
transposed = input.map(&:chars).transpose
operations = transposed.map(&:pop).reject { it.strip.empty? }
columns = transposed.map { it.join.to_i }.slice_when { it.zero? }.map { it.reject(&:zero?) }

puts columns.zip(operations).sum { |column, operation| solve(column, operation) }
