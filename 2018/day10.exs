defmodule Day10 do
  def part1 do
    # I figured out the number 10117 mostly by trial and error, it yielded the smallest
    # deltas between min_x, max_x, min_y, and max_y
    # I think the efficient way to do this is binary search a range of numbers until
    # you find the smallest delta between min_y and max_y
    Enum.reduce(1..10117, input(), fn _i, acc ->
      Enum.map(acc, fn {x, y, vx, vy} -> {x + vx, y + vy, vx, vy} end)
    end)
    |> draw
  end

  # TODO: lol
  def part2 do
    Enum.reduce(1..10117, input(), fn i, _acc -> i end)
  end

  defp draw(coords) do
    grid = Map.new(coords, fn {x, y, _, _} -> {{x, y}, "#"} end)

    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    length = Range.size(min_x..max_x)

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(length)
    |> Enum.map_join("\n", fn list ->
      Enum.map(list, fn coord -> Map.get(grid, coord, " ") end)
    end)
    |> IO.puts()
  end

  def input do
    File.stream!("day10.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn str ->
      String.replace(str, ["position", "velocity", "=", "<", ">", ","], "")
    end)
    |> Stream.map(&String.split/1)
    |> Stream.map(fn list -> Enum.map(list, &String.to_integer/1) |> List.to_tuple() end)
  end
end

Day10.part1()
Day10.part2() |> IO.puts
