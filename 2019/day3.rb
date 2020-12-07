require 'pry'

class Manhatten
  def initialize
    wires = File.read('day3.txt').split("\n")
    @wire1 = wires.first.split(',')
    @wire2 = wires.last.split(',')
  end

  def run
    wire1_locations = [[0,0]]
    wire2_locations = [[0,0]]

    [[@wire1, wire1_locations], [@wire2, wire2_locations]].each do |pair|
      pair.first.each do |instruction|
        send(instruction[0].downcase, instruction[1..].to_i, pair.last)
      end
    end

    intersections = wire1_locations[1..] & wire2_locations[1..]
    
    puts intersections.map { |coords| coords.first.abs + coords.last.abs }.min
    puts intersections.map { |coords| wire1_locations[1..].index(coords) + wire2_locations[1..].index(coords) + 2 }.min
  end

  private

  def u(distance, locations)
    current_location = locations.last

    ((current_location.last + 1)..(current_location.last + distance)).each do |i|
      locations << [current_location.first, i]
    end
  end

  def r(distance, locations)
    current_location = locations.last

    ((current_location.first + 1)..(current_location.first + distance)).each do |i|
      locations << [i, current_location.last]
    end
  end

  def d(distance, locations)
    current_location = locations.last

    ((current_location.last - distance)..(current_location.last - 1)).reverse_each do |i|
      locations << [current_location.first, i]
    end
  end

  def l(distance, locations)
    current_location = locations.last

    ((current_location.first - distance)..(current_location.first - 1)).reverse_each do |i|
      locations << [i, current_location.last]
    end
  end
end

Manhatten.new.run
