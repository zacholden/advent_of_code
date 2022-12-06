defmodule Day6 do
  @input File.read!("day6.txt") |> String.trim()

  def part1 do
    find_packet(@input, 4)
  end

  def part2 do
    find_packet(@input, 14)
  end

  defp find_packet(input, packet_size) do
    String.codepoints(input)
    |> Enum.chunk_every(packet_size, 1)
    |> Enum.with_index()
    |> Enum.find(fn {list, _idx} -> list == Enum.uniq(list) end)
    |> then(fn {_list, idx} -> idx + packet_size end)
  end
end

Day6.part1() |> IO.inspect()
Day6.part2() |> IO.inspect()
