defmodule Day10 do
  def part1 do
    grid = grid()

    {{x,y} = first, _} = Enum.find(grid, fn {_coords, val} -> val == "S" end)
    second = cond do
      grid[{x, y - 1}] in ["|", "7"] ->
        {x, y - 1}
        grid[{x + 1, y}] in ["-", "7"] ->
        {x + 1, y}
        grid[{x, y + 1}] in ["|", "J"] ->
        {x, y + 1}
        grid[{x - 1, y}] in ["-", "F"] ->
        {x - 1, y}
      end

    Stream.unfold([second, first], fn [l1, l2 | _rest] = locations ->
      current_pipe = grid[l1]

      next_loc = move(current_pipe, l1, l2)

      next_loc && {locations, [next_loc | locations]}
    end)
    |> Enum.to_list()
    |> List.last
    |> Enum.count
    |> div(2)
  end

  def move("|", {x1, y1}, {_x2, y2}) when y1 > y2, do: {x1, y1 + 1}
  def move("|", {x1, y1}, {_x2, y2}) when y1 < y2, do: {x1, y1 - 1}

  def move("-", {x1, y1}, {x2, _y2}) when x1 > x2, do: {x1 + 1, y1}
  def move("-", {x1, y1}, {x2, _y2}) when x1 < x2, do: {x1 - 1, y1}

  def move("L", {x1, y1}, {_x2, y2}) when y1 > y2, do: {x1 + 1, y1}
  def move("L", {x1, y1}, {x2, _y2}) when x1 < x2, do: {x1, y1 - 1}

  def move("J", {x1, y1}, {_x2, y2}) when y1 > y2, do: {x1 - 1, y1}
  def move("J", {x1, y1}, {x2, _y2}) when x1 > x2, do: {x1, y1 - 1}

  def move("7", {x1, y1}, {x2, _y2}) when x1 > x2, do: {x1, y1 + 1}
  def move("7", {x1, y1}, {_x2, y2}) when y1 < y2, do: {x1 - 1, y1}

  def move("F", {x1, y1}, {x2, _y2}) when x1 < x2, do: {x1, y1 + 1}
  def move("F", {x1, y1}, {_x2, y2}) when y1 < y2, do: {x1 + 1, y1}

  def move("S", _, _), do: nil

  def grid do
    File.read!("day10.txt")
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
end

Day10.part1() |> IO.inspect()
