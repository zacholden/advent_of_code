input = File.read('day04.txt').split.map { |str| str.split('') }

class Grid
  attr_reader :data, :columns, :rows

  def initialize(input)
    @data = input
    @columns = input.length
    @rows = input.first.length
  end

  def at(col, row)
    return nil if col.negative? || row.negative?

    data.dig(col, row)
  end

  def remove(col, row)
    data[col][row] = '.'
  end

  def neighbours(col, row)
    ([col - 1, col, col + 1].product([row - 1, row, row + 1]) - [[col, row]]).map { |arr| at(*arr) }
  end

  def traverse
    return enum_for(:traverse) unless block_given?

    columns.times do |c|
      rows.times do |r|
        yield data[c][r], c, r
      end
    end
  end
end

grid = Grid.new(input)

part1 = grid.traverse.count do |val, col, row|
  next if val != '@'
  next if grid.neighbours(col, row).count('@') >= 4

  val
end

puts part1

part2 = 0

loop do
  run = grid.traverse.count do |val, col, row|
    next if val != '@'
    next if grid.neighbours(col, row).count('@') >= 4

    grid.remove(col, row)
  end

  part2 += run
  break if run.zero?
end

puts part2
