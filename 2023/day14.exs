defmodule Day14 do
  def part1 do
    {grid, {min_x, max_x}, {min_y, max_y}} = input()

    scores = Enum.with_index(max_y..min_y, 1) |> Map.new()

    grid
    |> tilt_north(min_x..max_x, min_y..max_y)
    |> Enum.filter(fn {_, char} -> char == "O" end)
    |> Enum.reduce(0, fn {{_X, y}, _}, acc -> acc + scores[y] end)
  end

  def part2 do
    {grid, {min_x, max_x}, {min_y, max_y}} = input()

    scores = Enum.with_index(max_y..min_y, 1) |> Map.new()

    result =
      Enum.reduce(1..500, {grid, %{}}, fn i, {grid, score_map} ->
        lol = cycle(grid, min_x..max_x, min_y..max_y)

        score =
          Enum.filter(lol, fn {_, char} -> char == "O" end)
          |> Enum.reduce(0, fn {{_X, y}, _}, acc -> acc + scores[y] end)

        {lol, Map.update(score_map, score, [i], fn list -> [i | list] end)}
      end)
      |> then(fn {_a, b} ->
        Enum.map(b, fn {k, v} -> {k, Enum.reverse(v)} end)
        |> Map.new()
      end)

    outliers = Enum.filter(result, fn {_k, v} -> length(v) > 10 end)

    # in scores that happen a lot the same pattern emerges
    pattern =
      hd(outliers)
      |> elem(1)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> hd

    # a map of the first time one of the repeating scores happened to its score
    scores = Map.new(outliers, fn {k, v} -> {hd(v), k} end)

    find_score(scores, rem(1_000_000_000, pattern), pattern)
  end

  def find_score(scores, n, _pattern) when is_map_key(scores, n), do: scores[n]
  def find_score(scores, n, pattern), do: find_score(scores, n + pattern, pattern)

  def cycle(grid, x, y) do
    grid |> tilt_north(x, y) |> tilt_west(x, y) |> tilt_south(x, y) |> tilt_east(x, y)
  end

  def tilt_north(grid, min_x..max_x, min_y.._max_y) do
    Enum.reduce(min_x..max_x, grid, fn column, acc ->
      Enum.filter(grid, fn {{x, _y}, val} -> x == column && val == "O" end)
      |> Enum.sort_by(fn {{_x, y}, _} -> y end)
      |> Enum.reduce(acc, fn {{x, y}, "O"}, inner_acc ->
        coords =
          Enum.find_value(y..min_y, {x, 0}, fn row ->
            if Map.has_key?(inner_acc, {x, row - 1}), do: {x, row}
          end)

        Map.delete(inner_acc, {x, y}) |> Map.put(coords, "O")
      end)
    end)
  end

  def tilt_south(grid, min_x..max_x, _min_y..max_y) do
    Enum.reduce(min_x..max_x, grid, fn column, acc ->
      Enum.filter(grid, fn {{x, _y}, val} -> x == column && val == "O" end)
      |> Enum.sort_by(fn {{_x, y}, _} -> y end, :desc)
      |> Enum.reduce(acc, fn {{x, y}, "O"}, inner_acc ->
        coords =
          Enum.find_value(y..max_y, {x, max_y}, fn row ->
            if Map.has_key?(inner_acc, {x, row + 1}), do: {x, row}
          end)

        Map.delete(inner_acc, {x, y}) |> Map.put(coords, "O")
      end)
    end)
  end

  def tilt_east(grid, _min_x..max_x, min_y..max_y) do
    Enum.reduce(min_y..max_y, grid, fn row, acc ->
      Enum.filter(grid, fn {{_x, y}, val} -> y == row && val == "O" end)
      |> Enum.sort_by(fn {{x, _y}, _} -> x end, :desc)
      |> Enum.reduce(acc, fn {{x, y}, "O"}, inner_acc ->
        coords =
          Enum.find_value(x..max_x, {max_x, y}, fn column ->
            if Map.has_key?(inner_acc, {column + 1, y}), do: {column, y}
          end)

        Map.delete(inner_acc, {x, y}) |> Map.put(coords, "O")
      end)
    end)
  end

  def tilt_west(grid, min_x.._max_x, min_y..max_y) do
    Enum.reduce(max_y..min_y, grid, fn row, acc ->
      Enum.filter(grid, fn {{_x, y}, val} -> y == row && val == "O" end)
      |> Enum.sort_by(fn {{x, _y}, _} -> x end)
      |> Enum.reduce(acc, fn {{x, y}, "O"}, inner_acc ->
        coords =
          Enum.find_value(x..min_x, {0, y}, fn column ->
            if Map.has_key?(inner_acc, {column - 1, y}), do: {column, y}
          end)

        Map.delete(inner_acc, {x, y}) |> Map.put(coords, "O")
      end)
    end)
  end

  def input(filename \\ "day14.txt") do
    grid =
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

    min_to_max_x = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    min_to_max_y = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    grid = Enum.filter(grid, fn {_, char} -> char != "." end) |> Map.new()

    {grid, min_to_max_x, min_to_max_y}
  end

  def draw(grid, {min_x, max_x}, {min_y, max_y}) do
    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(max_x + 1)
    |> Enum.map_join("\n", fn list ->
      Enum.map_join(list, fn coord -> Map.get(grid, coord, ".") end)
    end)
    |> IO.puts()
  end
end

Day14.part1() |> IO.inspect()
Day14.part2() |> IO.inspect()
