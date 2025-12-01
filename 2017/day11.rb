input = File.read("day11.txt").chomp.split(",")

x = 0
y = 0
z = 0

max = 0

result = input.each do |dir|
  case dir
  when 'n'
    z -= 1
    y += 1
  when 'ne'
    z -= 1
    x += 1
  when 'se'
    x += 1
    y -= 1
  when 's'
    z += 1
    y -= 1
  when 'sw'
    z += 1
    x -= 1
  when 'nw'
    x -= 1
    y += 1
  end

  current = [x, y, z].max
  max = current if current > max
end

puts [x, y, z].max

puts max
