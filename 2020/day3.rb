GRID = File.read('day3.txt').split("\n").freeze
ROW_LENGTH = 31

def traverse(y, x)
  trees = 0
  position = [0, 0]

  loop do
    break if position.first >= GRID.length

    GRID[position.first][position.last] == '#' && trees += 1
    position[0] += y
    position[1] = (position[1] + x) % ROW_LENGTH
  end

  trees
end

p traverse(1, 3)
p [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]].reduce(1) { |acc, arr| traverse(*arr) * acc }
