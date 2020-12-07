require 'pry'

class Day10
  attr_reader :map
  # this grid is 42 by 42
  def initialize
    @map = File.read('day10.txt').split("\n").map { |str| str.split('') }.map { |arr| arr.map { |str| str == '#' && '#' || nil } }
  end

  def scan
    map.map.with_index do |arr, index_y|
      arr.map.with_index do |loc, index_x|
        next if loc.nil?
        count = 0
    
        (0..41).each do |y|
          (0..41).each do |x|
            next if map[y][x].nil?
            next if y == index_y && x == index_x
            next if blocked?(index_y, index_x, y, x)


            count += 1  
          end
        end

        count
      end
    end
  end

  private

  def blocked?(y1, x1, y2, x2)
    if y1 == y2 # on the same line
      if x2 > x1 # we are looking right
        map[y1][(x1 + 1)..(x2 - 1)].none?
      else # looking left
        map[y1][(x2 + 1)..(x1 - 1)].none?
      end
    else
      x_delta = (x1 - x2).abs
      y_delta = (y1 - y2).abs
      angle = x_delta / y_delta.to_f
      if y1 > y2 # looking up
        ((y2 - 1)..(y1 + 1)).none? do |y| 
          binding.pry
          next if angle != angle.to_i
          map[y][angle += angle]
        end
      elsif y1 < y2 # looking down
        ((y1 + 1)..(y2 - 1)).none? do |y| 
          next if angle != angle.to_i
          map[y][angle += angle]
        end
      end
    end
  end
end

puts Day10.new.scan.flatten.compact.max
