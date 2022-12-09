defmodule Day8 do
  @grid File.stream!("day8.txt")
        |> Stream.map(&String.trim/1)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {string, y_index}, acc ->
          String.codepoints(string)
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {height, x_index}, inner_acc ->
            Map.put(inner_acc, {x_index, y_index}, height)
          end)
          |> Map.merge(acc)
        end)

  def part1 do
    {min, max} =
      @grid |> Map.keys() |> Enum.map(&Tuple.to_list/1) |> List.flatten() |> Enum.min_max()

    Enum.count(@grid, fn {{x, y}, height} ->
      visible?(@grid, {x, y}, height, {min, max})
    end)
  end

  def part2 do
    {min, max} =
      @grid |> Map.keys() |> Enum.map(&Tuple.to_list/1) |> List.flatten() |> Enum.min_max()

    Enum.map(@grid, fn {{x, y}, height} ->
      score(@grid, {x, y}, height, {min, max})
    end)
    |> Enum.max()
  end

  def visible?(_, {x, y}, _, {min, max}) when x == min or x == max or y == min or y == max do
    true
  end

  def visible?(grid, {x, y}, height, {min, max}) do
    Enum.all?(min..(x - 1), fn i -> grid[{i, y}] < height end) ||
      Enum.all?((x + 1)..max, fn i -> grid[{i, y}] < height end) ||
      Enum.all?(min..(y - 1), fn i -> grid[{x, i}] < height end) ||
      Enum.all?((y + 1)..max, fn i -> grid[{x, i}] < height end)
  end

  def score(_, {x, y}, _, {min, max}) when x == min or x == max or y == min or y == max do
    0
  end

  def score(grid, {x, y}, height, {min, max}) do
    [
      look(grid, (y - 1)..min, height, {x, "y"}),
      look(grid, (x - 1)..min, height, {"x", y}),
      look(grid, (y + 1)..max, height, {x, "y"}),
      look(grid, (x + 1)..max, height, {"x", y})
    ]
    |> Enum.product()
  end

  def look(grid, range, height, {x, "y"}) do
    Enum.reduce_while(range, 0, fn i, acc ->
      if grid[{x, i}] >= height do
        {:halt, acc + 1}
      else
        {:cont, acc + 1}
      end
    end)
  end

  def look(grid, range, height, {"x", y}) do
    Enum.reduce_while(range, 0, fn i, acc ->
      if grid[{i, y}] >= height do
        {:halt, acc + 1}
      else
        {:cont, acc + 1}
      end
    end)
  end
end

Day8.part1() |> IO.inspect()
Day8.part2() |> IO.inspect()
