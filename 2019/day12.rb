require 'pry'
require 'set'

class Day12
  def initialize
    @planets = 
      File.read('day12.txt')
      .gsub('<', '{')
      .gsub('>', '}')
      .gsub('=', ': ')
      .split("\n")
      .map { |str| eval(str).merge(xv: 0, yv: 0, zv: 0) }
    @set = Set.new
  end

  def orbit
    (1..).each do |orb|
      (0..3).each do |i|
        planet = @planets[i]
        other_planets = @planets - [planet]

        planet[:xv] += 1 if other_planets[0][:x] > planet[:x]
        planet[:xv] -= 1 if other_planets[0][:x] < planet[:x]
        planet[:yv] += 1 if other_planets[0][:y] > planet[:y]
        planet[:yv] -= 1 if other_planets[0][:y] < planet[:y]
        planet[:zv] += 1 if other_planets[0][:z] > planet[:z]
        planet[:zv] -= 1 if other_planets[0][:z] < planet[:z]

        planet[:xv] += 1 if other_planets[1][:x] > planet[:x]
        planet[:xv] -= 1 if other_planets[1][:x] < planet[:x]
        planet[:yv] += 1 if other_planets[1][:y] > planet[:y]
        planet[:yv] -= 1 if other_planets[1][:y] < planet[:y]
        planet[:zv] += 1 if other_planets[1][:z] > planet[:z]
        planet[:zv] -= 1 if other_planets[1][:z] < planet[:z]

        planet[:xv] += 1 if other_planets[2][:x] > planet[:x]
        planet[:xv] -= 1 if other_planets[2][:x] < planet[:x]
        planet[:yv] += 1 if other_planets[2][:y] > planet[:y]
        planet[:yv] -= 1 if other_planets[2][:y] < planet[:y]
        planet[:zv] += 1 if other_planets[2][:z] > planet[:z]
        planet[:zv] -= 1 if other_planets[2][:z] < planet[:z]
      end

      @planets.each do |planet|
        planet[:x] += planet[:xv]
        planet[:y] += planet[:yv]
        planet[:z] += planet[:zv]
      end

    end

    #total = @planets.map do |planet|
    #  (planet[:x].abs + planet[:y].abs + planet[:z].abs) * (planet[:xv].abs + planet[:yv].abs + planet[:zv].abs)
    #end.sum
    #puts total
  end
end

Day12.new.orbit
