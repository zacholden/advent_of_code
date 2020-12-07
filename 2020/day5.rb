input = File.read('day5.txt').split("\n")
#input = %w[BFFFBBFRRR FFFBBBFRRR BBFFBBFRLL]

def bsearch(str)
  i, res = 0, 0
  bit_order = 2**(str.length-1)
  target = str.length == 7 ?  "B" : "R"

  loop do
    break if i == str.length
    str[i] == target && res += bit_order
    bit_order /= 2
    i += 1
  end  

  res
end

seats = input.map { |str| bsearch(str[0..6]) * 8 + bsearch(str[7..9]) }.sort

puts seats.last
puts (seats.first..seats.last).to_a.difference(seats)
