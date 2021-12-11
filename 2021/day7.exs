# input = [16,1,2,0,4,2,7,1,2,14]
input =
  File.read!("day7.txt") |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)

# part 1
number = Enum.min_by(input, fn i -> Enum.map(input, fn i2 -> abs(i - i2) end) |> Enum.sum() end)
Enum.reduce(input, 0, fn i, acc -> acc + abs(number - i) end) |> IO.inspect()

# part 2
{min, max} = Enum.min_max(input)
sum = fn i -> div(i * (i + 1), 2) end

number =
  Enum.min_by(min..max, fn i ->
    Enum.reduce(input, 0, fn i2, acc -> acc + sum.(abs(i - i2)) end)
  end)

Enum.reduce(input, 0, fn i, acc -> acc + sum.(abs(number - i)) end)
|> IO.inspect()
