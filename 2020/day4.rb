require 'set'

input = File.read('day4.txt').split("\n\n").map { |str| str.gsub("\n", " ").gsub(":", ":'").split.join("',") }.map { |str| eval('{' + str + "'}") }
fields = Set.new(%i[byr iyr eyr hgt hcl ecl pid cid])

p input.count { |hash| hash.keys.sort == fields.sort || hash.keys.sort == (fields - [:cid]).sort }

def valid_height?(str)
  if str&.end_with?('cm')
    (150..193).cover?(str.delete('cm').to_i)
  elsif str&.end_with?('in')
    (59..76).cover?(str.delete('in').to_i)
  else
    false
  end
end

def valid_hair?(str)
  return false unless str&.start_with?('#')

  str.delete('#').split('').all? { |char| (0..9).cover?(char.to_i) || ('a'..'f').cover?(char) }
end

def valid_pid?(str)
  str&.length == 9 && str.split("").all? { |i| (0..9).cover?(i.to_i) }
end

input.count do |hash|
  (1920..2002).cover?(hash[:byr].to_i) &&
    (2010..2020).cover?(hash[:iyr].to_i) &&
    (2020..2030).cover?(hash[:eyr].to_i) &&
    valid_height?(hash[:hgt]) &&
    valid_hair?(hash[:hcl]) &&
    %w[amb blu brn gry grn hzl oth].include?(hash[:ecl]) &&
    valid_pid?(hash[:pid])
end.then { |res| puts res }
