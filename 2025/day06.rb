input = File.read('day06.txt').split("\n")

def run(arr, operation)
  case operation
  when '*'
    arr.reduce(&:*)
  when '+'
    arr.sum
  end
end

# part 1
puts input.map(&:split).transpose.sum { |arr| run(arr[..-2].map(&:to_i), arr.last) }

# part 2
columns = input.map { |str| str.split('') }.transpose
operations = columns.map(&:pop).reject { |str| str.strip.empty? }

result = 0
i = 0
ops_idx = 0
problem = []

loop do
  val = columns[i]
  number = val.to_a.join.strip.to_i
  i += 1

  if number.zero?
    result += run(problem, operations[ops_idx])
    problem = []
    ops_idx += 1
  else
    problem << number
  end

  break if i > columns.length
end

puts result
