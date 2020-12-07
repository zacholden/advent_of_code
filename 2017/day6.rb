require 'set'

def mem_count(arr)
  permutations = Set.new

  loop do
    break unless permutations.add?(arr.dup)
    i = arr.index(arr.max)
    n = arr[i]
    arr[i] = 0
      loop do
        if arr[i + 1]
          arr[i + 1] += 1
        else
          arr[0] += 1
          i = -1
        end
        i += 1
        n -= 1
      break if n.zero?
    end
  end

  permutations.count
end
