defmodule Day8 do
  import MapSet

  @input File.read!("day8.txt")
         |> String.split("\n", trim: true)
         |> Enum.map(fn str ->
           [signal, output] = String.split(str, " | ")

           {
             String.split(signal)
             |> Enum.sort_by(&String.length/1)
             |> Enum.map(fn str -> String.codepoints(str) |> MapSet.new() end),
             String.split(output)
             |> Enum.map(fn str -> String.to_charlist(str) |> Enum.sort() |> List.to_string() end)
           }
         end)

  def part1 do
    lengths = [2, 3, 4, 7]

    Enum.reduce(@input, 0, fn {_signal_patterns, output}, acc ->
      acc + Enum.count(output, fn str -> byte_size(str) in lengths end)
    end)
  end

  def part2 do
    Enum.reduce(@input, 0, fn {signal_patterns, output}, acc ->
      acc + solve_row(signal_patterns, output)
    end)
  end

  defp solve_row([one, seven, four | tail], output) do
    two_three_five = Enum.slice(tail, 0, 3)
    zero_six_nine = Enum.slice(tail, 3, 3)
    eight = List.last(tail)

    three = Enum.find(two_three_five, fn set -> subset?(one, set) end)

    nine = Enum.find(zero_six_nine, fn set -> subset?(three, set) end)

    five = Enum.find(two_three_five, fn set -> subset?(set, nine) && set != three end)

    two = Enum.find(two_three_five, fn set -> set != five && set != three end)

    six = Enum.find(zero_six_nine, fn set -> subset?(five, set) && set != nine end)

    zero = Enum.find(zero_six_nine, fn set -> set != six && set != nine end)

    map = %{
      Enum.join(zero) => 0,
      Enum.join(one) => 1,
      Enum.join(two) => 2,
      Enum.join(three) => 3,
      Enum.join(four) => 4,
      Enum.join(five) => 5,
      Enum.join(six) => 6,
      Enum.join(seven) => 7,
      Enum.join(eight) => 8,
      Enum.join(nine) => 9
    }

    Enum.reduce(output, 0, fn str, acc -> acc * 10 + map[str] end)
  end
end

Day8.part1() |> IO.inspect()
Day8.part2() |> IO.inspect()
