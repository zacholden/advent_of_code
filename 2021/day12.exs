defmodule Day12 do
  @input "YW-end\nDK-la\nla-XG\nend-gy\nzq-ci\nXG-gz\nTF-la\nxm-la\ngy-gz\nci-start\nYW-ci\nTF-zq\nci-DK\nla-TS\nzq-YW\ngz-YW\nzq-gz\nend-gz\nci-TF\nDK-zq\ngy-YW\nstart-DK\ngz-DK\nzq-la\nstart-TF"
         |> String.split("\n")
         |> Enum.map(&String.split(&1, "-"))
         |> then(fn a_to_b -> Enum.concat(a_to_b, Enum.map(a_to_b, fn [a, b] -> [b, a] end)) end)
         |> Enum.reduce(%{}, fn [a, b], acc ->
           Map.update(acc, a, [b], fn list -> [b | list] end)
         end)

  def part1 do
    traverse(@input, ["start"], MapSet.new(), MapSet.new())
    |> Enum.count()
  end

  def part2 do
    traverse2(@input, ["start"], MapSet.new())
    |> Enum.count()
  end

  defp traverse(_map, ["end" | visited], _small_caves_visited, routes) do
    MapSet.put(routes, ["end" | visited])
  end

  defp traverse(map, [location | visited], small_caves_visited, routes) do
    if small_cave?(location) && MapSet.member?(small_caves_visited, location) do
      routes
    else
      Enum.flat_map(map[location], fn new_location ->
        small_caves_visited =
          if small_cave?(location),
            do: MapSet.put(small_caves_visited, location),
            else: small_caves_visited

        traverse(map, [new_location, location | visited], small_caves_visited, routes)
      end)
    end
  end

  defp traverse2(_map, ["end" | visited], routes), do: MapSet.put(routes, ["end" | visited])

  defp traverse2(map, [location | visited], routes) do
    if small_cave?(location) && multiple_small_caves_visited_twice?(location, visited) do
      routes
    else
      Enum.flat_map(map[location], fn new_location ->
        traverse2(map, [new_location, location | visited], routes)
      end)
    end
  end

  defp small_cave?(str), do: String.downcase(str) == str

  defp multiple_small_caves_visited_twice?("start", []), do: false
  defp multiple_small_caves_visited_twice?("start", [_head | _tail]), do: true

  defp multiple_small_caves_visited_twice?(cave, caves_visited) do
    visits =
      Enum.filter([cave | caves_visited], &small_cave?/1) |> Enum.frequencies() |> Map.values()

    cond do
      Enum.any?(visits, fn i -> i > 2 end) ->
        true

      Enum.count(visits, &(&1 > 1)) |> then(fn amount -> amount > 1 end) ->
        true

      true ->
        false
    end
  end
end

Day12.part1() |> IO.inspect()
Day12.part2() |> IO.inspect()
