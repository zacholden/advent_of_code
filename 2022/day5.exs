defmodule Day5 do
  @input File.read!("day5.txt") |> String.split("\n\n")
  @stacks Enum.map(1..36//4, fn i ->
            Enum.map(@input |> hd |> String.split("\n"), fn str -> String.at(str, i) end)
          end)
          |> Enum.map(fn list ->
            {List.last(list), Enum.take(list, 8) |> Enum.filter(&(&1 != " "))}
          end)
          |> Map.new()
  @commands List.last(@input)
            |> String.replace(~r{move|from|to}, "")
            |> String.split("\n", trim: true)
            |> Enum.map(&String.split/1)
            |> Enum.map(fn [quantity, from, to] -> {String.to_integer(quantity), from, to} end)

  def part1 do
    Enum.reduce(@commands, @stacks, fn {quantity, from, to}, stacks ->
      move(stacks, quantity, from, to)
    end)
    |> Enum.map_join(fn {_k, v} -> hd(v) end)
  end

  def part2 do
    Enum.reduce(@commands, @stacks, fn {quantity, from, to}, stacks ->
      crates = Enum.take(stacks[from], quantity)

      Map.update!(stacks, to, &(crates ++ &1)) |> Map.update!(from, &Enum.drop(&1, quantity))
    end)
    |> Enum.map_join(fn {_k, v} -> hd(v) end)
  end

  defp move(stacks, 0, _from, _to), do: stacks

  defp move(stacks, quantity, from, to) do
    crate = stacks[from] |> hd()

    updated_stacks = Map.update!(stacks, to, &[crate | &1]) |> Map.update!(from, &tl(&1))

    move(updated_stacks, quantity - 1, from, to)
  end
end

Day5.part1() |> IO.puts()
Day5.part2() |> IO.puts()
