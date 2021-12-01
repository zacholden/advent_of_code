# Part 1

File.stream!("day1.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(2, 1, :discard)
|> Enum.count(fn [a,b] -> a < b end)
|> IO.puts

# Part 2

File.stream!("day1.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(4, 1, :discard)
|> Enum.count(fn [a,b,c,d] -> a + b + c < b + c + d end)
|> IO.puts
