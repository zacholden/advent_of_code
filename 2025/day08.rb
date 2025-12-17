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
input.each_with_index.to_a.combination(2) { |(a, i), (b, j)| cache[[i, j]] = a.distance(b) }
ordered = cache.sort_by { |k, v| v }.map(&:first)
length = 1000

class BadUnionFind
  attr_reader :groups

  def initialize
    @groups = []
  end

  def find(a)
    groups.find { it.include?(a) }
  end

  def union(a, b)
    as = find(a)
    bs = find(b)

    if as && bs
      return if as == bs

      as_idx = groups.index(as)
      bs_idx = groups.index(bs)

      @groups[as_idx] = as.union(bs)
      @groups.delete_at(bs_idx)
    elsif as
      as << b
    elsif bs
      bs << a
    else
      @groups << [a, b]
    end
  end
end

# part 1

buf = BadUnionFind.new

length.times { |i| buf.union(*ordered[i]) }

puts buf.groups.sort_by(&:size).last(3).reduce(1) { |acc, group| acc * group.size }

# part 2

buf = BadUnionFind.new

ordered.each do |a, b|
  buf.union(a, b)

  next unless buf.groups.first.length == length

  break puts input[a].x * input[b].x
end
