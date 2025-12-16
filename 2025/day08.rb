class Coordinate
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  def distance(other)
    Math.sqrt((x - other.x)**2 + (y - other.y)**2 + (z - other.z)**2)
  end
end

input = File.read("day08.txt").split.map { it.split(',').map(&:to_i) }.map { Coordinate.new(*it) }

cache = {}

input.each.with_index do |coord, coord_idx|
  input.each.with_index do |other, other_idx|
    next if coord_idx == other_idx

    key = [coord_idx, other_idx].sort

    if cache.key?(key)
      next
    else
      cache[key] = coord.distance(other)
    end
  end
end

length = 1000

# part 1

groups = []
queue = cache.sort_by { |k, v| -v }.map(&:first)

length.times do
  a, b = queue.pop

  a_group = groups.find { it.include?(a) }
  b_group = groups.find { it.include?(b) }

  next if a_group && b_group && a_group == b_group

  if a_group && b_group
    a_idx = groups.index(a_group)
    b_idx = groups.index(b_group)

    groups[a_idx] = a_group + b_group
    groups.delete_at(b_idx)
  elsif a_group
    a_group << b
  elsif b_group
    b_group << a
  else
    groups << [a, b]
  end
end

puts groups.sort_by(&:size).last(3).reduce(1) { |acc, group| acc * group.size }

# part 2

groups = []
queue = cache.sort_by { |k, v| -v }.map(&:first)

loop do
  a, b = queue.pop

  a_group = groups.find { it.include?(a) }
  b_group = groups.find { it.include?(b) }

  next if a_group && b_group && a_group == b_group

  if a_group && b_group
    a_idx = groups.index(a_group)
    b_idx = groups.index(b_group)

    groups[a_idx] = a_group + b_group
    groups.delete_at(b_idx)
  elsif a_group
    a_group << b
  elsif b_group
    b_group << a
  else
    groups << [a, b]
  end

  if groups.first.length == length
    puts input[a].x * input[b].x
    break
  end
end
