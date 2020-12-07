class Firewall
  attr_reader :layers, :time

  def initialize(layers, delay)
    @layers = layers
    @delay = delay
    @score = 0
    @time = 0
    @original_delay = delay
    @original_delay.freeze
  end

  def start
    loop do
      tick
      break if delayed_time == layers.length
    end
    @score
  end

  def tick
    add_score if caught?
    @layers.each(&:scan)
    account_for_delay
    @time += 1
  end

  def caught?
    return false if @delay != 0
    return false if layers[@time - @original_delay].body.length == 0
    layers[@time - @original_delay].scanner_position.zero?
  end

  def account_for_delay
    if @delay == 0
      false
    else
      @delay -= 1
      true
    end
  end

  def add_score
    @score += (delayed_time * layers[@time].body.length)
  end
end

class Layer
  attr_reader :body, :scanner_position, :depth

  def initialize(depth, range)
    @depth = depth
    @body = Array.new(range)
    @scanner_position = 0
    @direction = "down"
  end

  def scan
    return nil if body.length == 0
    if @direction == "down"
      @scanner_position += 1
      change_direction if @scanner_position == ((body.length) - 1)
    else
      @scanner_position -= 1
      change_direction if @scanner_position.zero?
    end
  end

  def change_direction
    if @direction == 'down'
      @direction = 'up'
    else
      @direction = 'down'
    end
  end
end

# 444 too low
  
