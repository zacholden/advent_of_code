input =
  File.stream!("day02.txt")
  |> Stream.map(fn str -> String.split(str) |> Enum.map(&String.to_integer/1) end)

ascending = fn list -> Enum.all?(list, fn [a, b] -> a < b end) end
descending = fn list -> Enum.all?(list, fn [a, b] -> a > b end) end
safe = fn list -> Enum.all?(list, fn [a, b] -> abs(a - b) in 1..3 end) end

valid = fn list -> (ascending.(list) || descending.(list)) && safe.(list) end

Enum.count(input, fn list ->
  Enum.chunk_every(list, 2, 1, :discard) |> then(valid)
end)
|> IO.inspect()

Enum.count(input, fn list ->
  Enum.any?(0..(length(list) - 1), fn int ->
    List.delete_at(list, int) |> Enum.chunk_every(2, 1, :discard) |> then(valid)
  end)
end)
|> IO.inspect()
