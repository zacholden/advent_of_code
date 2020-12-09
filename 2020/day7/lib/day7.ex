defmodule Day7 do
  require IEx

  @moduledoc """
  Documentation for `Day7`.
  """

  @target "shiny gold bag"
  @input File.stream!("day7.txt")
         |> Enum.map(fn str ->
           String.replace(str, "bags", "bag")
           |> String.replace(".", "")
           |> String.trim
           |> String.split(" contain ")
         end)
         |> Stream.map(fn [k, v] ->
           {String.trim(k),
            String.split(v, ", ")
            |> Enum.map(fn str -> String.split(str, " ", parts: 2) |> Enum.map(&(String.trim/1)) |> List.to_tuple() end)
            |> Enum.into(%{})}
         end)
         |> Enum.into(%{})

  def part1() do
    build_list(MapSet.new(), [@target])
  end

  def build_list(set, [head | tail]) do
    leaves = Enum.filter(@input, fn {k,v} -> Enum.any?(Map.values(v), &(&1 == head)) end) |> Enum.into(%{}) |> Map.keys

    build_list(MapSet.union(set, MapSet.new(leaves)), tail ++ leaves)
  end

  def build_list(set, []), do: set |> IO.inspect

  def lol do
    @input
  end
end
