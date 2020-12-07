defmodule Day3 do
  def part1 do
    File.read!('day3.txt')
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&parse_sequence/1)
    |> plot_grid(Map.new)
    |> count_twos
  end

  def part2 do
    File.read!('day3.txt')
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_sequence_with_id/1)
    |> Enum.reduce(Map.new, &(Map.merge/2))
    |> find_plot
  end

  def find_plot(map) do
    map
    |> Enum.map(fn {k, v} -> compare_lists(k, v, Map.values(map)) end)
    |> Enum.find(fn i -> i != false end)
  end

  def compare_lists(k, list, list_of_lists) do
    res = list_of_lists
    |> Enum.filter(fn l -> Enum.empty?((MapSet.intersection(list, l))) end)
    |> Enum.count

    cond do
      res < 1372 -> false
      res == 1372 -> k
    end
  end

  def plot_grid(coordinate_list, grid) do
    coordinate_list
    |> Enum.reduce(grid, fn coord, acc -> Map.update(acc, coord, 1, &(&1 + 1)) end)
  end

  def count_twos(map) do
    map
    |> Map.values
    |> Enum.count(&(&1 > 1))
  end

  def parse_sequence_with_id(string) do
    [id, left, top, width, height] =
    string
    |> String.replace(",", " ")
    |> String.replace("x", " ")
    |> String.replace(":", "")
    |> String.replace("#", "")
    |> String.replace(" @", "")
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)

    %{ 
      id => MapSet.new(for x <- left..(left + width - 1), y <- top..(top + height - 1), do: {x,y})
    }
  end

  def parse_sequence(string) do
    [left, top, width, height] =
    string
    |> String.replace(",", " ")
    |> String.replace("x", " ")
    |> String.replace(":", "")
    |> String.split(" @ ")
    |> tl
    |> hd
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)

    for x <- left..(left + width - 1), y <- top..(top + height - 1), do: {x,y}
  end
end

Day3.part1() |> IO.puts()
Day3.part2() |> IO.puts()
