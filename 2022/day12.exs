defmodule Day12 do
  @grid File.stream!("day12.txt")
        |> Stream.map(&String.trim/1)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {string, y_index}, acc ->
          String.codepoints(string)
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {height, x_index}, inner_acc ->
            Map.put(inner_acc, {x_index, y_index}, height)
          end)
          |> Map.merge(acc)
        end)
  @scores Map.new(?a..?z, fn char -> {List.to_string([char]), char - 96} end)
          |> Map.merge(%{"S" => 1, "E" => 26})

  # Dijkstra's algorithm used here. It is slow and would be a lot faster if
  # the queue were a priority queue. Currently every read is a linear scan
  # and it should be faster.

  def part1 do
    {source, "S"} = Enum.find(@grid, fn {_k, v} -> v == "S" end)
    {target, "E"} = Enum.find(@grid, fn {_k, v} -> v == "E" end)

    dijkstra(@grid, source, target)
  end

  def graph do
    @grid
  end

  def part2 do
    {target, "E"} = Enum.find(@grid, fn {_k, v} -> v == "E" end)

    Enum.filter(@grid, fn {{x, y}, v} ->
      v == "a" &&
        Enum.any?([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], fn coords ->
          @grid[coords] == "b"
        end)
    end)
    |> Enum.map(fn {source, _} -> dijkstra(@grid, source, target) end)
    |> Enum.min()
  end

  def dijkstra(graph, source, target) do
    distances = %{source => 0}
    queue = Map.keys(graph) |> MapSet.new()

    search(graph, distances, queue, target)
  end

  def search(graph, distances, queue, target) do
    {x, y} = u = Enum.min_by(queue, fn key -> distances[key] end)

    if u == target do
      distances[u]
    else
      queue = MapSet.delete(queue, u)

      neighbours =
        Enum.filter([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], fn coords ->
          graph[coords] && @scores[graph[u]] + 1 >= @scores[graph[coords]]
        end)

      distances =
        for vertex <- neighbours,
            distance_from_source = distances[u] + 1,
            distance_from_source < Map.get(distances, vertex, :infinity),
            reduce: distances do
          distances -> Map.put(distances, vertex, distance_from_source)
        end

      search(graph, distances, queue, target)
    end
  end

  def draw(grid) do
    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(max_x + 1)
    |> Enum.map_join("\n", fn list ->
      Enum.map_join(list, fn coord -> Map.get(grid, coord, ".") end)
    end)
    |> IO.puts()
  end
end

Day12.part1() |> IO.inspect()
Day12.part2() |> IO.inspect()
