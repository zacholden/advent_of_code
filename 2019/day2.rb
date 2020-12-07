# To solve day part 1 memory[0] and memory[1] need to be 12 and 2

class Day2
  def initialize
    @init_memory = File.read('day2.txt').split(',').map(&:to_i)
  end

  def run
    (0..99).to_a.product((0..99).to_a).each do |pair|
      @location = 0
      @memory = @init_memory.dup
      @memory[1] = pair[0]
      @memory[2] = pair[1]

      loop do
        optcode = @memory[@location]
        case optcode
        when 1
          add(@memory[@location + 1], @memory[@location + 2], @memory[@location + 3])
        when 2
          mult(@memory[@location + 1], @memory[@location + 2], @memory[@location + 3])
        when 99
          break
        end
      end

      break if @memory[0] == 19690720
    end

    puts 100 * @memory[1] + @memory[2]
  end

  private

  def add(a, b, c)
    @memory[c] = @memory[a] + @memory[b]
    @location += 4
  end

  def mult(a, b, c)
    @memory[c] = @memory[a] * @memory[b]
    @location += 4
  end
end

Day2.new.run
