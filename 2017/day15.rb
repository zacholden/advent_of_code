def calculate_matches
  matches = 0
  a = 591
  b = 393
  ga_factor = 16807
  gb_factor = 48271
  divisor = 2147483647
  
  5_000_000.times do
    a = get_ting(a, ga_factor, divisor, 4)
    b = get_ting(b, gb_factor, divisor, 8)
    matches += 1 if a & 65535 == b & 65535
  end

  puts matches
end

def get_ting(old_value, factor, divisor, modulo)
  ting = old_value * factor % divisor
  return ting if ting % modulo == 0

  get_ting(ting, factor, divisor, modulo)
end

calculate_matches
# 617 too low
# 618 too low
  
