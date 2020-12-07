require 'pry'

class Manhatten
  DIRS = %i[right up left down]

  def spiral(start, finish)
    x = 0
    y = 0
    moves = 0
    dir = 0
    thresh = 0

    (start..finish).each do |location|
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

      moves += 1
      dir += 1 if moves.even?
      dir = 0 if dir == 4
    end

    puts moves
    puts (x.abs) + (y.abs)
  end
end

Manhatten.new.spiral(1, 361527)
