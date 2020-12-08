defmodule Day1 do
  @input File.stream!('day1.txt') |> Stream.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
  @goal 2020

  def part1 do
    @input
    |> TwoSum.find(@goal)
    |> Enum.reduce(&(&1 * &2))
  end

  def part2 do
    @input |> three_sum(@goal)
  end

  defp three_sum([head | tail], goal) do
    result = TwoSum.find(tail, goal - head)

    if result do
      [head | result] |> Enum.reduce(&(&1 * &2))
    else
      three_sum(tail, goal)
    end
  end
end

defmodule TwoSum do
  def find(list, goal) do
    run(list, goal, MapSet.new)
  end

  defp run([head | tail], goal, map) do
    if MapSet.member?(map, goal - head) do
      [head, goal - head]
    else
      run(tail, goal, MapSet.put(map, head))
    end
  end

  defp run([], _goal, _map), do: nil
end

Day1.part1 |> IO.puts
Day1.part2 |> IO.puts
