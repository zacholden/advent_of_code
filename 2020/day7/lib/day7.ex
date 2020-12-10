defmodule Day7 do
  require IEx

  @moduledoc """
  Solution to Advent of Code 2020 day 7.
  """

  @target "shiny gold bag"
  @input File.read!('day7.txt')
         |> String.replace(".", "")
         |> String.replace("bags", "bag")
         |> String.split("\n", trim: true)
         |> Enum.map(&String.split(&1, " contain "))
         |> Enum.map(fn list -> List.to_tuple(list) end)
         |> Enum.map(fn {k, v} -> {k, String.split(v, ", ")} end)
         |> Enum.map(fn {k, v} ->
           {k,
            Enum.map(v, fn str -> String.split(str, " ", parts: 2) end)
            |> Enum.reverse()
            |> Enum.map(&List.to_tuple/1)
            |> Enum.map(fn {k, v} -> {v, String.replace(k, "no", "0") |> String.to_integer()} end)
            |> Enum.into(%{})}
         end)
         |> Enum.into(%{})

  def part1 do
    build_list(MapSet.new(), [@target])
  end

  def part2 do
    find_weight(@target, 1)
  end

  def build_list(set, [head | tail]) do
    leaves =
      Enum.filter(@input, fn {_k, v} -> Map.keys(v) |> Enum.any?(&(&1 == head)) end)
      |> Enum.into(%{})
      |> Map.keys()

    build_list(MapSet.union(set, MapSet.new(leaves)), tail ++ leaves)
  end

  def build_list(set, []), do: set |> Enum.count()

  def find_weight(bag, depth) do
    rules = Map.get(@input, bag)
    local_weight = rules |> Enum.reduce(0, fn {_bag, amount}, acc -> acc + amount * depth end)

    if local_weight == 0 do
      local_weight
    else
      child_weights = Stream.map(rules, fn {k,v} -> find_weight(k, depth * v) end) |> Enum.sum
      local_weight + child_weights
    end
  end
end
