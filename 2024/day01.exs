{left, right} =
  File.stream!("day01.txt")
  |> Stream.map(fn str ->
    String.split(str) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end)
  |> Enum.unzip()

Enum.zip_reduce(Enum.sort(left), Enum.sort(right), 0, fn l, r, acc -> acc + abs(l - r) end)
|> IO.inspect()

frequencies = Enum.frequencies(right)

Enum.reduce(left, 0, fn i, acc -> acc + i * Map.get(frequencies, i, 0) end) |> IO.inspect()
