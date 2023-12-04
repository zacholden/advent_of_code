input =
  File.read!("day4.txt")
  |> String.replace("Card ", "")
  |> String.split("\n", trim: true)
  |> Enum.map(fn str ->
    [game, rest] = String.split(str, ":")
    [winners, numbers] = String.split(rest, " | ")

    {String.trim(game) |> String.to_integer(), String.split(winners) |> MapSet.new(),
     String.split(numbers)}
  end)

# Part 1
Enum.reduce(input, 0, fn {_round, set, numbers}, acc ->
  winners = Enum.count(numbers, fn num -> MapSet.member?(set, num) end)
  if winners == 0, do: acc, else: acc + Integer.pow(2, winners - 1)
end)
|> IO.inspect()

# Part 2
Enum.reduce(input, %{}, fn {round, set, numbers}, acc ->
  card_score = Enum.count(numbers, fn num -> MapSet.member?(set, num) end)

  if card_score == 0 do
    acc
  else
    current_quantity = Map.get(acc, round, 1)
    range = (round + 1)..(round + card_score)

    Enum.reduce(range, acc, fn i, inner_acc ->
      Map.update(inner_acc, i, current_quantity + 1, &(&1 + current_quantity))
    end)
  end
end)
|> Map.values()
|> Enum.sum()
|> IO.inspect()
