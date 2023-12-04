defmodule Day3 do
  @symbols ["/", "*", "@", "%", "$", "+", "=", "-", "#", "&"]
  @numbers "1234567890"

  def part1 do
    grid = grid()

    Enum.reduce(coords(grid), {0, MapSet.new()}, fn {x, y}, {acc_int, acc_set} ->
      char = grid[{x, y}]
      int = String.contains?(@numbers, char)

      if int && not MapSet.member?(acc_set, {x, y}) do
        number = full_number_right(grid, {x, y})
        number_size = Integer.digits(number) |> length

        new_set =
          Enum.reduce(x..(x + number_size), acc_set, fn x, acc -> MapSet.put(acc, {x, y}) end)

        count =
          if neighbors_symbol?(grid, {x, y}, number_size), do: number + acc_int, else: acc_int

        {count, new_set}
      else
        {acc_int, acc_set}
      end
    end)
    |> then(fn {acc_int, _} -> acc_int end)
  end

  def part2 do
    grid = grid()

    Enum.reduce(coords(grid), 0, fn {x, y}, acc ->
      char = grid[{x, y}]

      if char == "*" do
        set = neighbours(grid, {x, y})

        count =
          if Enum.count(set) == 2,
            do: Enum.to_list(set) |> Enum.map(&String.to_integer/1) |> Enum.product(),
            else: 0

        acc + count
      else
        acc
      end
    end)
  end

  def grid do
    File.read!("day3.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {str, y_idx}, acc ->
      String.codepoints(str)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {char, x_idx}, inner_acc ->
        Map.put(inner_acc, {x_idx, y_idx}, char)
      end)
      |> Map.merge(acc)
    end)
  end

  defp coords(grid) do
    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()
    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y}) |> Enum.sort_by(fn {_x, y} -> y end)
  end

  def neighbours(grid, {x, y}) do
    for(x <- (x - 1)..(x + 1), y <- (y - 1)..(y + 1), do: {x, y})
    |> Enum.filter(fn coord -> String.contains?(@numbers, grid[coord]) end)
    |> Enum.reduce(MapSet.new(), fn {x, y}, acc ->
      left =
        Enum.reduce_while((x - 1)..(x - 4), "", fn x, acc ->
          position = Map.get(grid, {x, y}, ".")

          if String.contains?(@numbers, position),
            do: {:cont, grid[{x, y}] <> acc},
            else: {:halt, acc}
        end)

      right =
        Enum.reduce_while((x + 1)..(x + 4), "", fn x, acc ->
          position = Map.get(grid, {x, y}, ".")

          if String.contains?(@numbers, position),
            do: {:cont, acc <> grid[{x, y}]},
            else: {:halt, acc}
        end)

      number = left <> grid[{x, y}] <> right

      MapSet.put(acc, number)
    end)
  end

  defp neighbors_symbol?(grid, {x, y}, size) do
    for(x <- (x - 1)..(x + size), y <- (y - 1)..(y + 1), do: {x, y})
    |> Enum.filter(fn {x, y} -> Map.get(grid, {x, y}, ".") in @symbols end)
    |> Enum.any?()
  end

  defp full_number_right(grid, {x, y}) do
    Enum.reduce_while((x + 1)..(x + 5), grid[{x, y}], fn x, acc ->
      position = Map.get(grid, {x, y}, ".")

      case Integer.parse(position) do
        :error -> {:halt, String.to_integer(acc)}
        _ -> {:cont, acc <> position}
      end
    end)
  end
end

Day3.part1() |> IO.inspect()
Day3.part2() |> IO.inspect()
