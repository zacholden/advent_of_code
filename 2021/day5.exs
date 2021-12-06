defmodule Day5 do
  @input File.read!("day5.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn str ->
           String.replace(str, " -> ", ",") |> String.split(",") |> Enum.map(&String.to_integer/1)
         end)
         |> Enum.map(&List.to_tuple/1)

  def part1 do
    Enum.filter(@input, fn {x1, y1, x2, y2} -> x1 == x2 || y1 == y2 end)
    |> Enum.reduce(Map.new(), fn {x1, y1, x2, y2}, grid ->
      keys(x1, y1, x2, y2)
      |> Enum.reduce(grid, fn key, acc -> Map.update(acc, key, 1, fn i -> i + 1 end) end)
    end)
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end

  def part2 do
    Enum.reduce(@input, Map.new(), fn {x1, y1, x2, y2}, grid ->
      keys(x1, y1, x2, y2)
      |> Enum.reduce(grid, fn key, acc -> Map.update(acc, key, 1, fn i -> i + 1 end) end)
    end)
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end

  def keys(x, y1, x, y2), do: Enum.map(y1..y2, fn y -> {x, y} end)
  def keys(x1, y, x2, y), do: Enum.map(x1..x2, fn x -> {x, y} end)
  def keys(x1, y1, x2, y2), do: Enum.zip(x1..x2, y1..y2)
end

Day5.part1() |> IO.inspect()
Day5.part2() |> IO.inspect()
