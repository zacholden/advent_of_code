registers = Hash.new(0)

commands = File.read("day08.txt").split("\n").map(&:split).each { |cmd| cmd[2] = cmd[2].to_i; cmd[6] = cmd[6].to_i }

high = 0

commands.each do |command|
comparsion = case command[5]
  when "=="
    registers[command[4]] == command[6]
  when "!="
    registers[command[4]] != command[6]
  when ">="
    registers[command[4]] >= command[6]
  when ">"
    registers[command[4]] > command[6]
  when "<="
    registers[command[4]] <= command[6]
  when "<"
    registers[command[4]] < command[6]
  end

  next unless comparsion

  case command[1]
  when "inc"
    registers[command.first] += command[2]
  when "dec"
    registers[command.first] -= command[2]
  end

  high = registers[command.first] if registers[command.first] > high
end

puts registers.values.max

puts high
