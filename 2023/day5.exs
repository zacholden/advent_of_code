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

  def part2 do
    {seeds, maps} = parse()

    seed_ranges = Enum.chunk_every(seeds, 2) |> Enum.map(fn [a,b] -> a .. a + b - 1 end) |> IO.inspect

    Enum.map(seed_ranges, fn srs..srf = seed_range ->
      Enum.reduce(maps, [], fn list_of_maps ->
        # this approach does not work because we need to retain the parts of the
        # range that are not used by the source ranges
        Enum.reduce(list_of_maps, fn {ds..df, ss..sf = source_range, _} ->
          cond do
            srs <= ss && srf >= sf ->
              [srs .. ss - 1, ds..df, sf + 1 ..srf]
            srs >= ss && srf <= sf ->
              delta = srs - ss
              [ds + delta .. ds + delta + Range.size(seed_range)]
            srs < ss && srf <= sf ->
              [srs .. ss - 1, ds .. ds + Range.size(seed_range)]
            srs > ss && srf >= sf ->
              delta = srs - ss
              run = Range.size(srs..sf)

              [ds + delta .. ds + delta + run, sf + 1 .. srf]
          end
        end)

      end) |> Enum.uniq |> IO.inspect
    end)
    |> Enum.map(fn range -> Enum.min(range) end)
    |> Enum.min
  end

  def parse do
    [seeds | maps] = File.read!("day5test.txt") |> String.split("\n\n")

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
Day5.part2() |> IO.inspect()
