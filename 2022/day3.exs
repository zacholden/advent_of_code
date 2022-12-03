defmodule Day3 do
  @input File.read!("day3.txt") |> String.split("\n", trim: true)
  @scores [?a..?z, ?A..?Z]
          |> Enum.concat()
          |> Enum.with_index(fn char, idx -> {List.to_string([char]), idx + 1} end)
          |> Map.new()

  def part1 do
    Enum.reduce(@input, 0, fn str, acc ->
      length = String.length(str) |> div(2)

      shared_item =
        String.split_at(str, length)
        |> Tuple.to_list()
        |> Enum.map(&String.codepoints/1)
        |> Enum.map(&MapSet.new/1)
        |> Enum.reduce(&MapSet.intersection/2)
        |> Enum.at(0)

      acc + @scores[shared_item]
    end)
  end

  # The badge is the shared item between a grouping of three elves
  def part2 do
    Enum.chunk_every(@input, 3)
    |> Enum.reduce(0, fn three_elves, acc ->
      badge =
        Enum.map(three_elves, &String.codepoints/1)
        |> Enum.map(&MapSet.new/1)
        |> Enum.reduce(&MapSet.intersection/2)
        |> Enum.at(0)

      acc + @scores[badge]
    end)
  end
end

Day3.part1() |> IO.inspect()
Day3.part2() |> IO.inspect()
