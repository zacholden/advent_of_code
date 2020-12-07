input = File.read('day1.txt').split("\n").map(&:to_i)
goal = 2020


def two_sum(input, goal)
  entries = {}

  input.find do |item|
    entries[item] = item
    
    if entries.key?(goal - item)
      true
    else
      false
    end
  end.then { |res| (res.nil? && return) || [res, (goal - res)] }
end

puts two_sum(input, goal).inject(:*)

entries = {}
input.map { |i| entries[i] = [i] }

input.each.with_index do |i, index|
  new_goal = goal - i
  new_input = input[(index + 1)..]

  arr = two_sum(new_input, new_goal) || next
  break puts (arr + [i]).inject(:*)
end
