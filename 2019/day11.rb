require 'pry'

class Day11
  def initialize
    @memory = File.read('day11.txt').chomp.split(',')
    #@memory = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99].map(&:to_s)
    #@memory = [1102,34915192,34915192,7,4,7,99,0].map(&:to_s)
    #@memory = [104,1125899906842624,99].map(&:to_s)
    @output_register = nil
    @relative_location = 0
    @location = 0
    @outputs = []
    @robot = Robot.new
  end

  def run(input)
    loop do
      instruction = @memory[@location].rjust(5, '0')
      
      optcode = instruction[-2..-1].to_i
      arg1 = parse_arg(@memory[@location + 1], instruction[-3])
      arg2 = parse_arg(@memory[@location + 2], instruction[-4])
      arg3 =
        if instruction[-5] == '0'
          @memory[@location + 3].to_i
        else
          @memory[@location + 3].to_i + @relative_location
        end

      case optcode
      when 1
        add(arg1, arg2, arg3)
      when 2
        mult(arg1, arg2, arg3)
      when 3
        if instruction[-3] == '2'
          store(@relative_location + @memory[@location + 1].to_i, @robot.position)
        else
          store(@memory[@location + 1].to_i, @robot.position)
        end
      when 4
        output(arg1)
      when 5
        jump_if_true(arg1, arg2)
      when 6
        jump_if_false(arg1, arg2)
      when 7
        less_than(arg1, arg2, arg3)
      when 8
        equal(arg1, arg2, arg3)
      when 9
        adjust_relative(arg1) 
      when 99
        break @output
      end
    end

    # part 1 @robot.locations.shift
    # @robot.locations.uniq.count
    @robot.locations
    image = @robot.grid.map do |row| 
      row.map do |int|
        str = int.to_s
        if str == '1'
          "\e[31m#{str}\e[0m"
        else
          "\e[32m#{str}\e[0m"
        end
      end
    end

    image.each { |row| puts row.join }
  end

  private

  def store(a, input)
    @memory[a] = input.to_s
    @location += 2
  end

  def output(a)
    @outputs << a
    @robot.move(*@outputs.last(2)) if @outputs.size.even?
    @location += 2
  end

  def add(a, b, c)
    @memory[c] = (a + b).to_s
    @location += 4
  end

  def mult(a, b, c)
    @memory[c] = (a * b).to_s
    @location += 4
  end

  def jump_if_true(a, b)
    unless a.zero?
      @location = b 
    else
      @location += 3
    end
  end

  def jump_if_false(a,b)
    if a.zero?
      @location = b 
    else
      @location += 3
    end
  end

  def less_than(a, b, c)
    if a < b
      @memory[c] = 1
    else
      @memory[c] = 0
    end
    @location += 4
  end

  def equal(a, b, c)
    if a == b
      @memory[c] = 1
    else
      @memory[c] = 0
    end
    @location += 4
  end

  def adjust_relative(a)
    @relative_location += a
    @location += 2
  end

  def parse_arg(arg, mode)
    case mode
    when '0'
      @memory[arg.to_i].to_i
    when '1'
      arg.to_i
    when '2'
      @memory[arg.to_i + @relative_location].to_i
    end
  end
end

class Robot
  DIRS = {
    up: [:left, :right],
    right: [:up, :down],
    down: [:right, :left],
    left: [:down, :up]
  }

  attr_reader :locations, :grid
  def initialize
    @grid = Array.new(65) { Array.new(150).fill(0) }
    @locations = [[32,75]] # The middle of an 11 by 11 grid
    # @grid[32][75] = 1 # this line makes the answer day 2
    @direction = :up
  end

  def location
    @locations.last
  end

  def position
    @grid[location.first][location.last]
  end

  def move(color, direction)
    @grid[location.first][location.last] = color
    @direction = DIRS[@direction][direction]

    case @direction
    when :up
      @locations << [location.first - 1, location.last]
    when :right
      @locations << [location.first, location.last + 1]
    when :down
      @locations << [location.first + 1, location.last]
    when :left
      @locations << [location.first, location.last - 1]
    end
  end
end

Day11.new.run(nil) # part 1
