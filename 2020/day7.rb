require 'set'
require 'pry'

input = File.read('day7.txt').delete(".").gsub(/\d/, "").gsub('bags', 'bag').split("\n").map { |str| str.split(" contain ") }
hash = Hash[input].transform_values { |val| Set.new(val.lstrip.split(",  ")) }
TARGET = 'shiny gold bag'

def search(hash, visited = Set.new, queue = [TARGET])
  target = queue.shift
  hits = hash.select { |key, values| values.include?(target) }.keys

  hits.each do |hit| 
    visited.add(hit)
    queue.push(hit)
  end
  
  if queue.empty?
    puts visited.length
  else
    search(hash, visited, queue)
  end
end

#search(hash.dup)

file = "shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."

file2 = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"

input = File.read('day7.txt').delete(".").gsub('bags', 'bag').split("\n").map { |str| str.split(" contain ") }
input = file.delete(".").gsub('bags', 'bag').split("\n").map { |str| str.split(" contain ") }
#input = file2.delete(".").gsub('bags', 'bag').split("\n").map { |str| str.split(" contain ") }
hash = Hash[input].transform_values { |v| v.strip.split(', ').map { |str| str.split(' ', 2) } }

# 170 too low
# 240 too low
# 95436781513680 too high
def find_weight(hash, target = TARGET, weight = 0)
  return weight if target == 'other bag'

  children = hash.fetch(target)

  weight += children.sum { |arr| arr.first.to_i * depth }
  weight += children.sum { |arr| find_weight(hash, arr.last, weight, arr.first.to_i + depth) }

  weight
end

p find_weight(hash.dup)
