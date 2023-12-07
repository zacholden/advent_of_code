defmodule Day5 do
  def part1 do
    {seeds, maps} = parse()

    Enum.map(seeds, fn seed ->
      Enum.reduce(maps, seed, fn ranges, acc ->
        range_tuple = Enum.find(ranges, fn {_, r, _} -> Enum.member?(r, acc) end)

        if range_tuple do
          {d_start.._, s_start.._, _length} = range_tuple

          acc - s_start + d_start
        else
          acc
        end
      end)
    end)
    |> Enum.min()
  end

  def parse do
    [seeds | maps] = File.read!("day5.txt") |> String.split("\n\n")

    seeds =
      String.split(seeds, ": ") |> tl |> hd |> String.split() |> Enum.map(&String.to_integer/1)

    maps =
      Enum.map(maps, fn str -> String.split(str, "\n", trim: true) end)
      |> Enum.map(&tl/1)
      |> Enum.map(fn list ->
        Enum.map(list, fn str ->
          String.split(str) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        end)
        |> Enum.map(fn {d_range, s_range, length} ->
          {d_range..(d_range + (length - 1)), s_range..(s_range + (length - 1)), length}
        end)
      end)

    {seeds, maps}
  end
end

Day5.part1() |> IO.inspect()
