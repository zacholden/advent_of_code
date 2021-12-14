defmodule Day13 do
  @input File.read!("day13.txt") |> String.split("\n\n")
  # @input File.read!("day13test.txt") |> String.split("\n\n")
  @coords @input
          |> hd
          |> String.split("\n")
          |> Enum.map(fn str ->
            String.split(str, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
          end)
  @folds @input
         |> List.last()
         |> String.split("\n", trim: true)
         |> Enum.map(fn str -> String.split(str, "=") end)
         |> Enum.map(fn [x_or_y, int] -> {String.last(x_or_y), String.to_integer(int)} end)

  def part1 do
    map = Enum.reduce(@coords, %{}, fn coord, acc -> Map.put(acc, coord, "#") end)

    fold(map, hd(@folds))
    |> Enum.count()
  end

  def part2 do
    map = Enum.reduce(@coords, %{}, fn coord, acc -> Map.put(acc, coord, "#") end)

    Enum.reduce(@folds, map, fn instruction, acc ->
      fold(acc, instruction)
    end)
    |> draw
  end

  defp fold(map, {"x", line}) do
    Enum.reduce(map, map, fn {{x, y}, val}, acc ->
      cond do
        x > line ->
          Map.put(acc, {line - (x - line), y}, val) |> Map.delete({x, y})

        x == line ->
          Map.delete(acc, {x, y})

        true ->
          acc
      end
    end)
  end

  defp fold(map, {"y", line}) do
    Enum.reduce(map, map, fn {{x, y}, val}, acc ->
      cond do
        y > line ->
          Map.put(acc, {x, line - (y - line)}, val) |> Map.delete({x, y})

        y == line ->
          Map.delete(acc, {x, y})

        true ->
          acc
      end
    end)
  end

  def draw(map) do
    {min_x, max_x} = Map.keys(map) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(map) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(max_x + 1)
    |> Enum.reduce("", fn list, acc ->
      line = (Enum.map(list, fn coord -> Map.get(map, coord, ".") end) |> Enum.join()) <> "\n"
      acc <> line
    end)
    |> IO.puts()
  end
end

Day13.part1() |> IO.inspect()
Day13.part2()
