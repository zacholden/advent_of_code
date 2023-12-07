input =
  "Time:        40     81     77     72
  Distance:   219   1012   1365   1089"

data =
  String.split(input, "\n")
  |> Enum.map(fn str ->
    String.split(str, ":") |> tl |> hd |> String.split() |> Enum.map(&String.to_integer/1)
  end)
  |> then(fn [l1, l2] -> Enum.zip(l1, l2) end)

# Part 1
Enum.map(data, fn {time, record} ->
  Enum.count(1..time, fn i -> i * (time - i) > record end)
end)
|> Enum.product()
|> IO.inspect()

# Part 2
Enum.reduce(data, {[], []}, fn {a, b}, {l1, l2} ->
  {[a | l1], [b | l2]}
end)
|> then(fn {a, b} ->
  {Enum.reverse(a) |> Enum.flat_map(&Integer.digits/1) |> Integer.undigits(),
   Enum.reverse(b) |> Enum.flat_map(&Integer.digits/1) |> Integer.undigits()}
end)
|> then(fn {time, record} ->
  Enum.count(1..time, fn i -> i * (time - i) > record end)
end)
|> IO.inspect()
