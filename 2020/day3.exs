defmodule Day3 do
  @grid File.stream!('day3.txt') |> Enum.map(&String.trim/1)
  @grid_length @grid |> Enum.count()
  @grid_width @grid |> hd |> String.length()

  def part1 do
    traverse({0, 0}, 0, 1, 3)
  end

  def part2 do
    [{1, 1}, {1, 3}, {1, 5}, {1, 7}, {2, 1}]
    |> Enum.map(fn {y, x} -> Task.async(fn -> traverse({0, 0}, 0, y, x) end) end)
    |> Task.await_many
    |> Enum.reduce(&(&1 * &2))
  end

  def traverse({pos_y, _pos_x}, trees, _y, _x) when pos_y >= @grid_length do
    trees
  end

  def traverse({pos_y, pos_x}, trees, y, x) do
    case @grid |> Enum.at(pos_y) |> String.at(pos_x) do
      "." ->
        traverse({pos_y + y, rem(pos_x + x, @grid_width)}, trees, y, x)

      "#" ->
        traverse({pos_y + y, rem(pos_x + x, @grid_width)}, trees + 1, y, x)
    end
  end
end

Day3.part1() |> IO.puts()
Day3.part2() |> IO.puts()
