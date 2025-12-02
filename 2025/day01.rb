input = File.read("day01.txt").split.map { |str| [str[0], str[1..].to_i] }

size = 100

# part 1
zeros = 0
position = 50

input.each do |arr|
  if arr.first == "L"
    position = (position - arr[1]) % size
  else
    position = (position + arr[1]) % size
  end

  zeros += 1 if position.zero?
end

puts zeros

#part 2

zeros = 0
position = 50

input.each do |arr|
  hundreds, remainder = arr[1].divmod(size)
  old_pos = position

  if arr.first == "L"
    position = (position - remainder) % size

    covers_zero = !old_pos.zero? && (position.zero? || old_pos < position)
  else
    position = (position + remainder) % size

    covers_zero = !old_pos.zero? && (position.zero? || old_pos > position)
  end

  tens = covers_zero ? 1 : 0

  zeros += (hundreds + tens)
end

puts zeros
