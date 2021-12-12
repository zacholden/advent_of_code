defmodule Day11 do
  @input """
         4743378318
         4664212844
         2535667884
         3273363861
         2282432612
         2166612134
         3776334513
         8123852583
         8181786685
         4362533174
         """
         |> String.split("\n", trim: true)
         |> Enum.map(&String.graphemes/1)
         |> Enum.map(&Enum.with_index(&1))
         |> Enum.with_index()
         |> Enum.reduce(%{}, fn {list, y_index}, acc ->
           Enum.reduce(list, acc, fn {num, x_index}, inner_acc ->
             Map.put(inner_acc, {x_index, y_index}, String.to_integer(num))
           end)
         end)

  def part1 do
    tick(@input, 0, 100)
  end

  # lol
  def part2 do
    tick(@input, 0, -1)
  end

  def tick(_, flashes, 0), do: flashes

  def tick(map, flashes, remaining) do
    updated_map =
      Enum.reduce(map, %{}, fn {{x, y}, num}, acc ->
        Map.put(acc, {x, y}, num + 1)
      end)

    {flashed_map, flash_count} =
      Enum.filter(updated_map, fn {_, num} -> num > 9 end)
      |> Enum.map(fn {coords, _num} -> coords end)
      |> flash(updated_map, 0)

    # TODO part 2 is the truthy case here
    if flash_count == 100 do
      abs(remaining)
    else
      tick(flashed_map, flashes + flash_count, remaining - 1)
    end
  end

  defp flash([{x, y} | tail], map, count) do
    new_map = Map.put(map, {x, y}, 0)

    updated_map =
      for(nx <- (x - 1)..(x + 1), ny <- (y - 1)..(y + 1), {x, y} != {nx, ny}, do: {nx, ny})
      |> Enum.reduce(new_map, fn coord, acc ->
        case acc[coord] do
          nil ->
            acc

          0 ->
            acc

          number ->
            Map.update!(acc, coord, &(&1 + 1))
        end
      end)

    new_coords =
      Enum.filter(updated_map, fn {_, num} -> num > 9 end)
      |> Enum.reduce(tail, fn {coords, _}, acc -> [coords | acc] end)
      |> Enum.uniq()

    flash(new_coords, updated_map, count + 1)
  end

  defp flash([], map, count), do: {map, count}
end

Day11.part1() |> IO.inspect()
Day11.part2() |> IO.inspect()
