defmodule Day6 do
  def part1 do
    File.read!('day6.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ", "))
    |> Enum.map(fn [a, b] -> %{x: String.to_integer(a), y: String.to_integer(b)} end)
  end
end
