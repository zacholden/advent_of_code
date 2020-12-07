class Duet
  def initialize(instructions)
    @instructions = instructions
    @position = 0
    @sound = nil
    set_registers
  end

  def sing
    loop do
      send(current_position.first, current_position[1], current_position[2])
      @position += 1 unless current_position.first == "jgz" && current_position[1] > 0
    end
  end

  def snd(*args)
    @sound = args.first
  end

  def set(x,y)
    x = y
  end

  def mul(x,y)
    x *= y
  end

  def mod(x,y)
    x %= y
  end

  def rcv(*args)
    return if args.first.zero?
    args.first = @sound
    puts args.first
  end

  def jgz(x,y)
    return if x.zero?
    @position += y
  end

  private

  def current_position
    @instructions[@position]
  end

  def set_registers
    @instructions.each do |arr|
      instance_variable_set(arr[1], 0) unless arr[1].is_a?(Integer)
    end
  end
end
