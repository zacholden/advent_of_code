defmodule Day11 do
  def part1 do
    grid() |> expand(2) |> pairs |> Map.values() |> Enum.sum()
  end

  def part2 do
    grid() |> expand(1_000_000) |> pairs |> Map.values() |> Enum.sum()
  end

  def expand(grid, multiple) do
    # I am not sure I know why
    multiple = multiple - 1

    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    empty_columns =
      Enum.filter(min_x..max_x, fn x ->
        Enum.all?(min_y..max_y, fn y -> grid[{x, y}] == "." end)
      end)

    empty_rows =
      Enum.filter(min_y..max_y, fn y ->
        Enum.all?(min_x..max_x, fn x -> grid[{x, y}] == "." end)
      end)

    galaxies = Enum.filter(grid, fn {{_x, _y}, space} -> space == "#" end)

    Enum.reduce(galaxies, %{}, fn {{x, y}, galaxy}, acc ->
      new_x = Enum.count(empty_columns, fn c -> c < x end) * multiple + x
      new_y = Enum.count(empty_rows, fn r -> r < y end) * multiple + y

      Map.put(acc, {new_x, new_y}, galaxy)
    end)
  end

  def pairs(grid) do
    galaxies =
      Enum.filter(grid, fn {{_x, _y}, space} -> space == "#" end)
      |> Enum.map(fn {{x, y}, "#"} -> {x, y} end)

    Enum.reduce(galaxies, %{}, fn {x, y}, acc ->
      Enum.reduce(galaxies, acc, fn {gx, gy}, inner_acc ->
        cond do
          {gx, gy} == {x, y} ->
            inner_acc

          Map.has_key?(inner_acc, {{gx, gy}, {x, y}}) ->
            inner_acc

          Map.has_key?(inner_acc, {{x, y}, {gx, gy}}) ->
            inner_acc

          true ->
            Map.put(inner_acc, {{x, y}, {gx, gy}}, abs(x - gx) + abs(y - gy))
        end
      end)
      |> Map.merge(acc)
    end)
  end

  def grid(filename \\ "day11.txt") do
    File.read!(filename)
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {str, y_idx}, acc ->
      String.codepoints(str)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {char, x_idx}, inner_acc ->
        Map.put(inner_acc, {x_idx, y_idx}, char)
      end)
      |> Map.merge(acc)
    end)
  end

  def draw(grid) do
    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(max_x + 1)
    |> Enum.map_join("\n", fn list ->
      Enum.map_join(list, fn coord -> Map.get(grid, coord, ".") end)
    end)
    |> IO.puts()
  end
end

Day11.part1() |> IO.inspect()
Day11.part2() |> IO.inspect()
