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
    positions = Map.new(0..8, fn i -> {i, 0} end) |> Map.merge(Enum.frequencies(@input))

    Enum.reduce(1..256, {positions, nil}, fn _day, {fish, prev} ->
      Enum.reduce(8..0, {fish, prev}, fn day, {fish, prev} ->
        case day do
          8 ->
            prev = fish[7]
            updated = Map.replace(fish, 7, fish[8])

            {updated, prev}

          0 ->
            updated =
              Map.replace(fish, 8, prev)
              |> Map.update!(6, &(&1 + prev))

            {updated, nil}

          number ->
            new_prev = fish[number - 1]
            updated = Map.replace(fish, number - 1, prev)

            {updated, new_prev}
        end
      end)
    end)
    |> then(fn {fish, _} -> Map.values(fish) |> Enum.sum() end)
  end
end

Day6.part1() |> IO.inspect()
Day6.part2() |> IO.inspect()
