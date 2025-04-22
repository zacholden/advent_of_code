input = File.read("day10.txt")

def sparse_hash(arr, lengths, runs = 1)
  index = 0
  skip_level = 0

  runs.times do
    lengths.each do |length|
      arr.rotate!(index)
      arr[0, length] = arr[0, length].reverse
      arr.rotate!(-index)

      index = (index + length + skip_level) % arr.length
      skip_level += 1
    end
  end

  arr
end

lengths = input.split(",").map(&:to_i)
arr = (0..255).to_a
bytes = sparse_hash(arr, lengths)

puts bytes[0] * bytes[1]

lengths = input.chomp.bytes + [17, 31, 73, 47, 23]
arr = (0..255).to_a

bytes = sparse_hash(arr, lengths, 64)

puts bytes.each_slice(16).reduce('') { |acc, arr| acc + arr.reduce(&:^).to_s(16) }
