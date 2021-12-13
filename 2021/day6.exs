defmodule Day6 do
  # @input [3, 4, 3, 1, 2]
  @input File.read!("day6.txt") |> String.split(",") |> Enum.map(&String.to_integer/1)

  def part1 do
    Enum.reduce(1..80, @input, fn _day, fish ->
      Enum.reduce(fish, [], fn i, acc ->
        if i == 0 do
          [6 | acc] |> then(fn list -> [8 | list] end)
        else
          [i - 1 | acc]
        end
      end)
    end)
    |> Enum.count()
  end

  def part2 do
    positions =
      Map.new(0..8, fn i -> {i, 0} end)
      |> Map.merge(Enum.frequencies(@input))
      |> Map.values()
      |> List.to_tuple()

    Enum.reduce(1..256, positions, fn _day, {p1, p2, p3, p4, p5, p6, p7, p8, p9} ->
      {p2, p3, p4, p5, p6, p7, p8 + p1, p9, p1}
    end)
    |> Tuple.sum()
  end
end

Day6.part1() |> IO.inspect()
Day6.part2() |> IO.inspect()
