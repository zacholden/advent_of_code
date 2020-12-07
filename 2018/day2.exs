defmodule Day2 do
  def part1 do
    parse_file() |> count_occurences(0, 0)
  end

  def part2() do
    parse_file()
    |> Enum.map(&(String.graphemes(&1)))
    |> find_fabric
  end

  defp find_fabric([head | tail]) do
    find_fabric(head, tail, tail)
  end

  defp find_fabric(head, [head2 | tail], original) do
    if compare_id(head, head2, 0) > 24 do
      find_fabric(head, head2)
    else
      find_fabric(head, tail, original)
    end
  end

  defp find_fabric(_, [], [head | tail]) do
    find_fabric(head, tail, tail)
  end

  defp find_fabric(id1, id2) do
    find_common_letters(id1, id2, []) |> Enum.reverse
  end

  defp compare_id([h1 | t1], [h2 | t2], score) do
    if h1 == h2 do
      compare_id(t1, t2, score + 1)
    else
      compare_id(t1, t2, score)
    end
  end

  defp compare_id([], [], score), do: score

  defp find_common_letters([h1 | t1], [h2 | t2], list) do
    if h1 == h2 do
      find_common_letters(t1, t2, [h1 | list])
    else
      find_common_letters(t1, t2, list)
    end
  end

  defp find_common_letters([], [], list), do: list

  defp count_occurences([head | tail], twos, threes) do
    values = head |> count_letters |> Map.values |> Enum.uniq
    count_occurences(
      tail,
      twos + Enum.count(values, &(&1 == 2)),
      threes + Enum.count(values, &(&1 == 3))
    )
  end

  defp count_occurences([], twos, threes) do
    twos * threes
  end

  defp count_letters(str) do
    str
    |> String.split("", trim: true)
    |> Enum.reduce(%{}, fn i, acc -> Map.update(acc, i, 1, &(&1 + 1)) end)
  end

  def parse_file do
    File.read!('day2.txt') |> String.split("\n", trim: true)
  end
end

Day2.part1() |> IO.puts()
Day2.part2() |> IO.puts()
