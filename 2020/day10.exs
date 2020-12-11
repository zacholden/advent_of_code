defmodule Day10 do
  @input File.stream!('day10t.txt') |> Stream.map(&String.trim/1) |> Stream.map(&String.to_integer/1) |> Enum.sort

  def part1 do
    find_adapter(@input, 0, 0, 0)
  end

  def find_adapter([head | tail], current, ones, threes) do
    case head - current do
      1 ->
       find_adapter(tail, head, ones + 1, threes) 
      3 ->
       find_adapter(tail, head, ones, threes + 1) 
    end
  end

  def find_adapter([], _current, ones, threes) do
    IO.inspect(threes)
    IO.inspect(ones)
    (threes + 1) * ones
  end
end

Day10.part1 |> IO.puts
