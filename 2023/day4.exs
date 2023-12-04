input =
  File.read!("day4.txt")
  |> String.replace("Card ", "")
  |> String.split("\n", trim: true)
  |> Enum.map(fn str ->
    [game, rest] = String.split(str, ":")
    [winners, numbers] = String.split(rest, " | ")

    winners =
      MapSet.intersection(
        String.split(winners) |> MapSet.new(),
        String.split(numbers) |> MapSet.new()
      )
      |> Enum.count()

    {String.trim(game) |> String.to_integer(), winners}
  end)

# Part 1
Enum.reduce(input, 0, fn {_round, winners}, acc -> acc + Bitwise.bsl(1, winners - 1) end)
|> IO.inspect()

# Part 2
reducer = fn
  {_round, 0}, acc ->
    acc

  {round, winners}, acc ->
    current_quantity = Map.get(acc, round, 1)
    range = (round + 1)..(round + winners)

    Enum.reduce(range, acc, fn i, inner_acc ->
      Map.update(inner_acc, i, current_quantity + 1, &(&1 + current_quantity))
    end)
end

Enum.reduce(input, %{}, reducer)
|> Map.values()
|> Enum.sum()
|> IO.inspect()
