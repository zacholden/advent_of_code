defmodule Day9 do
  @input File.stream!('day9.txt') |> Stream.map(&String.trim/1) |> Enum.map(&String.to_integer/1)
  def part1 do
    find_missing(@input, 0, 25)
  end

  def part2 do
    find_sums_of_missing(@input, 0, part1())
  end

  def find_sums_of_missing(list, index, goal) do
    {sum, tries} =
      Enum.drop(list, index)
      |> Enum.reduce_while({0, 0}, fn i, acc ->
        {sum, tries} = acc

        if sum + i >= goal do
          {:halt, {sum + i, tries + 1}}
        else
          {:cont, {sum + i, tries + 1}}
        end
      end)

    if sum == goal && tries > 1 do
      new_list =
        Enum.drop(list, index)
        |> Enum.take(tries)
        |> Enum.sort()

      List.first(new_list) + List.last(new_list)
    else
      find_sums_of_missing(list, index + 1, goal)
    end
  end

  defp find_missing(list, index, amount) do
    goal = Enum.at(list, index + amount)

    if Enum.slice(list, index, amount) |> TwoSum.find(goal) do
      find_missing(list, index + 1, amount)
    else
      goal
    end
  end
end

defmodule TwoSum do
  def find(list, goal) do
    run(list, goal, MapSet.new())
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

Day9.part1() |> IO.puts()
Day9.part2() |> IO.puts()
