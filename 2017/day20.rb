require 'set'

class Particle
  attr_reader :index, :position
  def initialize(index, position, velocity, acceleration)
    @index, @position, @velocity, @acceleration = index, position, velocity, acceleration
    @deleted = false
  end

  def tick
    @velocity[0] += @acceleration[0]
    @velocity[1] += @acceleration[1]
    @velocity[2] += @acceleration[2]
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
    @position[2] += @velocity[2]
  end

  def distance
    @position[0].abs + @position[1].abs + @position[2].abs
  end

  def deleted
    @deleted
  end

  def delete
    @deleted = true
  end
end

class Container
  def initialize(particles)
    @particles = particles
  end

  def positions
    @particles.reject(&:deleted).map(&:position)
  end

  def tick
    @particles.each(&:tick)
    remove_duplicates
  end

  def remove_duplicates
    positions.each do |position|
      dups = @particles.select { |particle| particle.position == position }
      if dups.size > 1
        dups.each(&:delete)
      else
        nil
      end
    end
  end
end

