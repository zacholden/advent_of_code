# Part 1

File.stream!("day1.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(2, 1, :discard)
|> Enum.count(fn [a, b] -> a < b end)
|> IO.inspect()

# Part 2

File.stream!("day1.txt")
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(4, 1, :discard)
|> Enum.count(fn [a, _b, _c, d] -> d > a end)
|> IO.inspect()
