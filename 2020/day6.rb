p File.read('day6.txt').split("\n\n").sum { |str| str.delete("\n").split('').uniq.count }
p File.read('day6.txt').split("\n\n").map { |str| str.split("\n") }.map { |arr| arr.map { |inner_arr| inner_arr.split('') }.reduce { |acc, i| acc & i } }.sum(&:size)
