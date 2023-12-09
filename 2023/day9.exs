defmodule Day9 do
  @input File.stream!("day9.txt")
         |> Enum.map(fn str -> String.split(str) |> Enum.map(&String.to_integer/1) end)

  def part1 do
    Enum.map(@input, fn list ->
      recur(list) + List.last(list)
    end)
    |> Enum.sum()
  end

  def part2 do
    Enum.map(@input, fn list ->
      recur(Enum.reverse(list)) + hd(list)
    end)
    |> Enum.sum()
  end

  def recur(list) do
    if Enum.all?(list, fn i -> i == 0 end) do
      0
    else
      new_list = Enum.chunk_every(list, 2, 1, :discard) |> Enum.map(fn [a, b] -> b - a end)
      List.last(new_list) + recur(new_list)
    end
  end
end

Day9.part1() |> IO.inspect()
Day9.part2() |> IO.inspect()
