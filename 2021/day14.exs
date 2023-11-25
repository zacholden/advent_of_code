defmodule Day14 do
  @template "KHSNHFKVVSVPSCVHBHNP" |> String.codepoints()
  @rules File.read!("day14.txt")
         |> String.split("\n\n")
         |> List.last()
         |> String.split("\n", trim: true)
         |> Map.new(fn str -> String.split(str, " -> ") |> List.to_tuple() end)

  def part1 do
    Stream.iterate(@template, fn template -> insert(template) end)
    |> Stream.drop(10)
    |> Enum.take(1)
    |> hd
    |> Enum.frequencies()
    |> Enum.min_max_by(fn {_k, v} -> v end)
    |> then(fn {{_min_key, min}, {_max_key, max}} -> max - min end)
  end

  def insert([e1, e2 | rest]) when is_map_key(@rules, e1 <> e2) do
    [e1, @rules[e1 <> e2] | insert([e2 | rest])]
  end

  def insert([e1, e2 | rest]) do
    [e1 | insert([e2 | rest])]
  end

  def insert(last), do: last
end

Day14.part1() |> IO.inspect()
