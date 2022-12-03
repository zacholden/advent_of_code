defmodule Day3 do
  @input File.read!("day3.txt") |> String.split("\n", trim: true)
  @scores [?a..?z, ?A..?Z]
          |> Enum.concat()
          |> Enum.with_index(fn char, idx -> {List.to_string([char]), idx + 1} end)
          |> Map.new()

  def part1 do
    Enum.reduce(@input, 0, fn str, acc ->
      item =
        String.split_at(str, div(String.length(str), 2))
        |> Tuple.to_list()
        |> shared_item()

      acc + @scores[item]
    end)
  end

  # The badge is the shared item between a grouping of three elves
  def part2 do
    Enum.chunk_every(@input, 3)
    |> Enum.reduce(0, fn elves, acc -> acc + @scores[shared_item(elves)] end)
  end

  def shared_item(list_of_strings) do
    Enum.map(list_of_strings, &String.codepoints/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.at(0)
  end
end

Day3.part1() |> IO.inspect()
Day3.part2() |> IO.inspect()
