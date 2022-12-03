defmodule Day2 do
  @input File.stream!("day2.txt") |> Stream.map(&String.trim/1) |> Enum.map(&String.split/1)
  @scores %{"X" => 1, "Y" => 2, "Z" => 3}

  def part1 do
    Enum.reduce(@input, 0, fn [opponent, us], acc ->
      roll(opponent, us) + acc
    end)
  end

  def part2 do
    Enum.reduce(@input, 0, fn [opponent, us], acc ->
      strategize(opponent, us) + acc
    end)
  end

  defp roll("A", "X"), do: 3 + @scores["X"]
  defp roll("B", "Y"), do: 3 + @scores["Y"]
  defp roll("C", "Z"), do: 3 + @scores["Z"]
  defp roll("A", "Y"), do: 6 + @scores["Y"]
  defp roll("B", "Z"), do: 6 + @scores["Z"]
  defp roll("C", "X"), do: 6 + @scores["X"]
  defp roll(_a, b), do: @scores[b]

  defp strategize("A", "X"), do: roll("A", "Z")
  defp strategize("A", "Y"), do: roll("A", "X")
  defp strategize("A", "Z"), do: roll("A", "Y")
  defp strategize("B", "X"), do: roll("B", "X")
  defp strategize("B", "Y"), do: roll("B", "Y")
  defp strategize("B", "Z"), do: roll("B", "Z")
  defp strategize("C", "X"), do: roll("C", "Y")
  defp strategize("C", "Y"), do: roll("C", "Z")
  defp strategize("C", "Z"), do: roll("C", "X")
end

Day2.part1() |> IO.inspect()
Day2.part2() |> IO.inspect()
