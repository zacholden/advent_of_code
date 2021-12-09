defmodule Day8 do
  @input File.read!("Day8.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn str -> String.split(str, " | ") end)
         |> Enum.map(fn [signal, output] -> [String.split(signal), String.split(output)] end)
  @signal_map ["a", "b", "c", "d", "e", "f", "g"] |> Enum.map(&{&1, nil}) |> Map.new()
  # mapping 
  #  aaaa        1111
  # b    c      2    3
  # b    c      2    3
  #  dddd   to   4444
  # e    f      5    6
  # e    f      5    6
  #  gggg        7777

  @unique_display_lengths MapSet.new([2, 3, 4, 7])
  # for 1, 4, 7, 8

  def part1 do
    Enum.map(@input, fn [_signal_patterns, output] ->
      Enum.count(output, fn str ->
        MapSet.member?(@unique_display_lengths, String.length(str))
      end)
    end)
    |> Enum.sum()
  end

  def part2 do
    Enum.map(@input, fn [signal_patterns, output] ->
      solve_row(
        Enum.sort_by(signal_patterns, &String.length/1) |> String.graphemes() |> MapSet.new,
        ouput,
        @signal_map
      )
    end)
  end

  defp solve_row([one, seven, four | tail], output, map) do
    # top bar
    top_bar = MapSet.difference(seven, one)
    map = Map.update(map, top_bar, 1)

    [right_side1, right_side2] = MapSet.to_list(one)

    two_three_five = Enum.filter(tail, & Enum.count(&1) == 5)
    zero_six_nine = Enum.filter(tail, & Enum.count(&1) == 6)

    three = Enum.find(two_three_five, fn set -> MapSet.member?(set, right_side_1) && MapSet.member?(set, right_side_2) end)

    middle_bar = MapSet.intersection(four, three) |> MapSet.difference(one)

    map = Map.update(map, middle_bar, 4)


    five = Enum.find(two_three_five, 

  end
end

Day8.part1() |> IO.inspect()
