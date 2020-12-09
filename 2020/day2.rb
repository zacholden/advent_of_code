def valid?(range, letter, password)
  range.cover?(password.count(letter))
end

def xor?(range, letter, password)
  (password[range.begin - 1] == letter) ^ (password[range.end - 1] == letter)
end

input = File
  .read('day2.txt')
  .split("\n")
  .map { |line| line.delete(':').gsub('-', '..').split }
  .each { |arr| arr[0] = eval(arr[0]) }

puts input.count { |line| valid?(*line) }
puts input.count { |line| xor?(*line) }
