defmodule Day6 do
  @input File.read!("day6.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn str -> String.split(str, ", ") |> Enum.map(&String.to_integer/1) end)
         |> Enum.map(&List.to_tuple/1)
  # @input [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]

  def part1 do
    {min_x, max_x, min_y, max_y} = grid_boundries()

    grid =
      for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
      |> Enum.reduce(Map.new(), fn {x, y}, acc ->
        scores =
          Enum.reduce(@input, Map.new(), fn {x2, y2}, inner_acc ->
            Map.put(inner_acc, {x2, y2}, abs(x2 - x) + abs(y2 - y))
          end)

        [lowest, second_lowest] = Map.values(scores) |> Enum.sort() |> Enum.take(2)

        if lowest == second_lowest do
          acc
        else
          {{closest_x, closest_y}, _score} = Enum.find(scores, fn {_k, v} -> v == lowest end)
          Map.put(acc, {x, y}, {closest_x, closest_y})
        end
      end)

    bad_coords =
      Stream.filter(grid, fn {{x, y}, _coords} ->
        x == min_x || x == max_x || y == min_y || y == max_y
      end)
      |> Enum.map(fn {_x_and_y, coords} -> coords end)
      |> MapSet.new()

    non_infinite_scores =
      Enum.reject(grid, fn {_x_and_ym, coords} -> MapSet.member?(bad_coords, coords) end)
      |> Enum.into(%{})

    non_infinite_scores
    |> Map.values()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.max()
  end

  def part2 do
    {min_x, max_x, min_y, max_y} = grid_boundries()

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.filter(fn {x, y} ->
      Enum.map(@input, fn {x2, y2} -> abs(x2 - x) + abs(y2 - y) end) |> Enum.sum() < 10_000
    end)
    |> Enum.count()
  end

  defp grid_boundries do
    {min_x, max_x} = Enum.map(@input, fn {x, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = Enum.map(@input, fn {_, y} -> y end) |> Enum.min_max()

    {min_x, max_x, min_y, max_y}
  end
end

Day6.part1() |> IO.inspect()
Day6.part2() |> IO.inspect()
