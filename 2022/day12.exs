defmodule Day12 do
  @grid File.stream!("day12.txt")
        |> Stream.map(&String.trim/1)
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {string, y_index}, acc ->
          String.codepoints(string)
          |> Enum.map(fn string ->
            if string in ["S", "E"], do: string, else: hd(String.to_charlist(string)) - 96
          end)
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {height, x_index}, inner_acc ->
            Map.put(inner_acc, {x_index, y_index}, height)
          end)
          |> Map.merge(acc)
        end)

  def lol do
    @grid
  end

  def part1 do
    {{start_x, start_y}, "S"} = Enum.find(@grid, fn {_k, v} -> v == "S" end)

    current_score = 1
  end

  defp possible_moves(grid, {x, y}, current_score) do
    [
      grid[{x - 1, y}],
      grid[{x + 1, y}],
      grid[{x, y + 1}],
      grid[{x, y - 1}]
    ]
    |> Enum.filter(fn val -> val && current_score + 1 >= val end)
  end
end

Day12.part1() |> IO.inspect()
