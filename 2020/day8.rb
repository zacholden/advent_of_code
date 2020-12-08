require 'set'
require 'pry'
FILE = File.read('day8.txt').split("\n")

class Day8
  def initialize
    @instructions = FILE.dup
    @acc = 0
    @position = 0
    @swap_idx = 0
  end

  def inspect
    "acc: #{@acc}\n position: #{@position}"
  end

  def part1(visited = Set.new)
    loop do
      if visited.add?(@position)
        eval(@instructions[@position])
      else
        break
      end
    end

    puts @acc
  end

  def part2(visited = Set.new)
    loop do
      break if @position == @instructions.size

      if visited.add?(@position)
        eval(@instructions[@position])
      else
        break
      end
    end

    if @position >= @instructions.length - 1
      puts @acc
    else
      @instructions = FILE.dup
      @acc = 0
      @position = 0

      loop do
        case @instructions[@swap_idx][0..2]
        when 'jmp'
          @instructions[@swap_idx] = @instructions[@swap_idx].gsub('jmp', 'nop')
          break
        when 'nop'
          @instructions[@swap_idx] = @instructions[@swap_idx].gsub('nop', 'jmp')
          break
        else
          @swap_idx += 1
        end
      end

      @swap_idx += 1

      part2
    end
  end

  private

  def jmp(int)
    @position += int
  end

  def acc(int)
    @acc += int
    @position += 1
  end

  def nop(int)
    @position += 1
  end
end

Day8.new.part1
Day8.new.part2
