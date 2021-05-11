defmodule Day7 do
  # @input File.read!('day7test.txt')
  @input File.read!("day7.txt")

  def part1 do
    parsed =
      @input
      |> String.split("\n", trim: true)
      |> Enum.map(fn str ->
        String.replace(str, "Step ", "")
        |> String.replace(" can begin.", "")
        |> String.split(" must be finished before step ")
      end)

    keys = parsed |> Stream.flat_map(fn a -> a end) |> Enum.uniq() |> MapSet.new()

    graph =
      parsed
      |> Enum.map(&Enum.reverse/1)
      |> Enum.reduce(%{}, fn list, acc ->
        Map.update(acc, hd(list), tl(list), fn existing_value -> existing_value ++ tl(list) end)
      end)

    letters =
      MapSet.difference(keys, MapSet.new(Map.keys(graph))) |> MapSet.to_list() |> Enum.sort()

    traverse(letters, graph, [])
  end

  def traverse([head | tail], graph, result) do
    new_graph =
      Enum.map(graph, fn {k, v} -> {k, v -- [head]} end)
      |> Enum.filter(fn {_k, v} -> v != [] end)
      |> Enum.into(%{})

    new_letters = MapSet.difference(MapSet.new(Map.keys(graph)), MapSet.new(Map.keys(new_graph)))

    new_keys = (tail ++ MapSet.to_list(new_letters)) |> Enum.sort()

    traverse(new_keys, new_graph, [head | result])
  end

  def traverse([], _, result) do
    Enum.reverse(result)
  end
end

Day7.part1() |> IO.puts