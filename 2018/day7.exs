defmodule Day7 do
  # @input File.read!("day7test.txt")
  @input File.read!("day7.txt")
         |> String.split("\n", trim: true)
         |> Stream.map(fn str ->
           String.replace(str, "Step ", "")
           |> String.replace(" can begin.", "")
           |> String.split(" must be finished before step ")
         end)
         |> Enum.map(&List.to_tuple/1)

  def part1 do
    keys = @input |> Stream.flat_map(&Tuple.to_list/1) |> Enum.uniq()

    graph =
      @input
      |> Enum.reduce(%{}, fn {value, key}, acc ->
        Map.update(acc, key, [value], fn existing_value -> [value | existing_value] end)
      end)

    letters = (keys -- Map.keys(graph)) |> Enum.sort()

    traverse(letters, graph, [])
  end

  def traverse([head | tail], graph, result) do
    new_graph =
      Stream.map(graph, fn {k, v} -> {k, v -- [head]} end)
      |> Stream.filter(fn {_k, v} -> v != [] end)
      |> Enum.into(%{})

    new_keys = ((Map.keys(graph) -- Map.keys(new_graph)) ++ tail) |> Enum.sort()

    traverse(new_keys, new_graph, [head | result])
  end

  def traverse([], _, result) do
    Enum.reverse(result)
  end
end

Day7.part1() |> IO.puts()
