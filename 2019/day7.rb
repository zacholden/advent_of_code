require 'pry'

class Day7
  def initialize
    # @init_memory = File.read('day7.txt').chomp.split(',').freeze
    @memory = [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0].map(&:to_s)
    @output = 0
    @hack = 0
  end

  def run(input)
    loop do
      instruction = @memory[@location].rjust(4, '0')
      optcode = instruction[-2..-1].to_i

      arg1 = instruction[-3] == '1' ? @memory[@location + 1] : @memory[@memory[@location + 1].to_i]
      arg2 = instruction[-4] == '1' ? @memory[@location + 2] : @memory[@memory[@location + 2].to_i]

      case optcode
      when 1
        add(arg1.to_i, arg2.to_i, @memory[@location + 3].to_i)
      when 2
        mult(arg1.to_i, arg2.to_i, @memory[@location + 3].to_i)
      when 3
        if @hack.zero?
          store(@memory[@location + 1], input)
        else
          store(@memory[@location + 1], @output)
        end
      when 4
        break output(@memory[@location + 1])
      when 5
        jump_if_true(arg1.to_i, arg2.to_i)
      when 6
        jump_if_false(arg1.to_i, arg2.to_i)
      when 7
        less_than(arg1.to_i, arg2.to_i, @memory[@location + 3].to_i)
      when 8
        equal(arg1.to_i, arg2.to_i, @memory[@location + 3].to_i)
      when 99
        break @output
      end
    end
  end

  private

  def store(a, input)
    @memory[a.to_i] = input.to_s
    @hack += 1
    @location += 2
  end

  def output(a)
    @output = @memory[a.to_i].to_i
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
end
