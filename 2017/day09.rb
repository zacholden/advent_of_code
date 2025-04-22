input = File.read("day09.txt")

bracket_depth = 0
score = 0
garbage_state = false
skip_character = false
garbage = 0

input.each_char do |item|
  if skip_character
    skip_character = false
    next
  end

  if item == "<" && garbage_state == false
    garbage_state = true
    next
  end

  if item == "!"
    skip_character = true
    next
  end

  if item == ">"
    garbage_state = false
    next
  end

  if garbage_state
    garbage += 1
    next
  end

  if item == "{"
    bracket_depth += 1
  end

  if item == "}"
    score += bracket_depth
    bracket_depth -= 1
  end
end

# part 1
puts score
# part 2
puts garbage
