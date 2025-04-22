require 'set'

memory = File.read("day06.txt").chomp.split("\t").map(&:to_i)

def count_permutations(arr)
  set = Set.new

  loop do
    break unless set.add?(arr.hash)

    i = arr.index(arr.max)
    n = arr[i]
    arr[i] = 0
      loop do
        one_over = (i + 1) % arr.length
        arr[one_over] += 1
        i = one_over
        n -= 1
        break if n.zero?
      end
  end

  set.count
end

# part 1
puts count_permutations(memory)

# part 2
puts count_permutations(memory)
