defmodule Day9 do
  @input File.read!("day9.txt")
         |> String.split("\n")
         |> Enum.map(&String.graphemes/1)
         |> Enum.map(&Enum.with_index(&1))
         |> Enum.with_index()
         |> Enum.reduce(%{}, fn {list, y_index}, acc ->
           Enum.reduce(list, acc, fn {num, x_index}, inner_acc ->
             Map.put(inner_acc, {x_index, y_index}, String.to_integer(num))
           end)
         end)

  def part1 do
    Stream.filter(@input, fn {{x, y}, num} ->
      [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
      |> Enum.all?(fn coords -> Map.get(@input, coords) > num end)
    end)
    |> Stream.map(fn {_x, y} -> y end)
    |> Stream.map(&(&1 + 1))
    |> Enum.sum()
  end

  def part2 do
    Enum.reduce(@input, [], fn {{x, y}, num}, acc ->
      if num == 9 do
        acc
      else
        if Enum.any?(acc, fn set -> MapSet.member?(set, {x, y}) end) do
          acc
        else
          [search(MapSet.new(), {x, y}) | acc]
        end
      end
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  defp search(set, {x, y}) do
    case @input[{x, y}] do
      9 ->
        set

      nil ->
        set

      _ ->
        if MapSet.member?(set, {x, y}) do
          set
        else
          MapSet.put(set, {x, y})
          |> search({x + 1, y})
          |> search({x - 1, y})
          |> search({x, y + 1})
          |> search({x, y - 1})
        end
    end
  end
end

Day9.part1() |> IO.inspect()
Day9.part2() |> IO.inspect()
