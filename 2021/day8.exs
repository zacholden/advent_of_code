defmodule Day8 do
  import MapSet

  @input File.read!("Day8.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn str -> String.split(str, " | ") end)
         |> Enum.map(fn [signal, output] -> [String.split(signal), String.split(output)] end)
         |> Enum.map(fn [signal, output] ->
           [
             Enum.sort_by(signal, &String.length/1)
             |> Enum.map(fn str -> String.graphemes(str) |> MapSet.new() end),
             output |> Enum.map(fn str -> String.graphemes(str) |> Enum.sort() |> Enum.join() end)
           ]
         end)

  def part1 do
    unique_display_lengths = MapSet.new([2, 3, 4, 7])

    Enum.map(@input, fn [_signal_patterns, output] ->
      Enum.count(output, fn str ->
        member?(unique_display_lengths, String.length(str))
      end)
    end)
    |> Enum.sum()
  end

  def part2 do
    Enum.reduce(@input, 0, fn [signal_patterns, output], acc ->
      acc + solve_row(signal_patterns, output)
    end)
  end

  defp solve_row([one, seven, four | tail], output) do
    eight = List.last(tail)

    two_three_five = Enum.filter(tail, &(Enum.count(&1) == 5))
    zero_six_nine = Enum.filter(tail, &(Enum.count(&1) == 6))

    three = Enum.find(two_three_five, fn set -> subset?(one, set) end)

    middle_bar = intersection(four, three) |> difference(one) |> Enum.at(0)

    nine = Enum.find(zero_six_nine, fn set -> difference(set, three) |> Enum.count() == 1 end)

    top_left = difference(nine, three) |> Enum.at(0)
    six = Enum.find(zero_six_nine, fn set -> member?(set, middle_bar) && set != nine end)
    zero = Enum.find(zero_six_nine, fn set -> set != six && set != nine end)
    five = Enum.find(two_three_five, fn set -> member?(set, top_left) end)
    two = Enum.find(two_three_five, fn set -> set != five && set != three end)

    map = %{
      Enum.join(zero) => "0",
      Enum.join(one) => "1",
      Enum.join(two) => "2",
      Enum.join(three) => "3",
      Enum.join(four) => "4",
      Enum.join(five) => "5",
      Enum.join(six) => "6",
      Enum.join(seven) => "7",
      Enum.join(eight) => "8",
      Enum.join(nine) => "9"
    }

    Enum.reduce(output, "", fn str, acc -> acc <> map[str] end) |> String.to_integer()
  end
end

Day8.part1() |> IO.inspect()
Day8.part2() |> IO.inspect()
