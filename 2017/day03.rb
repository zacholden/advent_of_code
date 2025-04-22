  DIRS = %i[right up left down]
  input = File.read("day03.txt").chomp.to_i

  location = 1
  x = 0
  y = 0
  dir = 0
  run_length = 1
  run = 0
  turns = 0

  loop do
    break puts x.abs + y.abs if location == input

    case DIRS[dir]
    when :right
      x += 1
    when :up
      y += 1
    when :left
      x -= 1
    when :down
      y -= 1
    end

    run += 1

    if run == run_length
      turns += 1
      run_length += 1 if turns.even?
      dir = (dir + 1) % 4
      run = 0
    end

    location += 1
  end

  location = 1
  x = 10
  y = 10
  dir = 0
  run_length = 1
  run = 0
  turns = 0

  grid = Array.new(20) { Array.new(20) }

  grid[10][10] = 1

  loop do
    case DIRS[dir]
    when :right
      x += 1
    when :up
      y += 1
    when :left
      x -= 1
    when :down
      y -= 1
    end

    score = grid[y-1][x-1].to_i + grid[y-1][x].to_i + grid[y-1][x+1].to_i + grid[y][x-1].to_i + grid[y][x+1].to_i + grid[y+1][x+1].to_i + grid[y+1][x].to_i + grid[y+1][x-1].to_i
    grid[y][x] = score

    break puts score if score > input

    run += 1

    if run == run_length
      turns += 1
      run_length += 1 if turns.even?
      dir = (dir + 1) % 4
      run = 0
    end
  end
