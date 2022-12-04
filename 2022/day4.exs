defmodule Day4 do
  @input File.read!("day4.txt")
         |> String.replace(~r{,|-}, " ")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.split/1)
         |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)
         |> Enum.map(fn [a1, a2, b1, b2] ->
           [Range.new(a1, a2) |> MapSet.new(), Range.new(b1, b2) |> MapSet.new()]
         end)

  def part1 do
    Enum.count(@input, fn [set1, set2] ->
      MapSet.subset?(set1, set2) || MapSet.subset?(set2, set1)
    end)
  end

  def part2 do
    Enum.count(@input, fn [set1, set2] -> !MapSet.disjoint?(set1, set2) end)
  end
end

Day4.part1() |> IO.inspect()
Day4.part2() |> IO.inspect()
