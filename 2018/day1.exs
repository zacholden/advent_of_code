defmodule Day1 do
  def part1 do
    File.read!('day1.txt')
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, &(String.to_integer(&1) + &2))
  end

  def part2 do
    File.read!('day1.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> find_frequency
  end

  defp find_frequency(instructions) do
    find_frequency(instructions, instructions, MapSet.new(), 0)
  end

  defp find_frequency([head | tail], instructions, set, frequency) do
    new_frequency = head + frequency

    case MapSet.member?(set, new_frequency) do
      true ->
        new_frequency

      false ->
        find_frequency(tail, instructions, MapSet.put(set, new_frequency), new_frequency)
    end
  end

  defp find_frequency([], instructions, set, frequency) do
    find_frequency(instructions, instructions, set, frequency)
  end
end

Day1.part1() |> IO.puts()
Day1.part2() |> IO.puts()
