defmodule Day11 do
  @input File.stream!('day11.txt')
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.split(&1, "", trim: true))
         |> Stream.map(fn list ->
           Enum.with_index(list) |> Enum.into(%{}, fn {list, index} -> {index, list} end)
         end)
         |> Stream.with_index()
         |> Enum.into(%{}, fn {map, index} -> {index, map} end)

  def part1 do
    generation(@input)
  end

  def generation(grid) do
    grid
  end

  def lol do
    @input
  end
end
