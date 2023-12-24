defmodule Day13 do
  def part1 do
    input()
    |> Enum.map(fn grid -> vertical(grid) || horizontal(grid) end)
    |> Enum.sum()
  end

  def part2 do
    input()
    |> Enum.map(fn grid -> vertical_smudge(grid) || horizontal_smudge(grid) end)
    |> Enum.sum()
  end

  def horizontal(grid) do
    max_x = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    Enum.chunk_every(0..max_y, 2, 1, :discard)
    |> Enum.find_value(fn [y1, y2] ->
      if Enum.all?(0..max_x, fn x -> grid[{x, y1}] == grid[{x, y2}] end) do
        cond do
          y2 == 1 || y2 == max_y ->
            y2 * 100

          Enum.zip((y2 + 1)..max_y, (y1 - 1)..0)
          |> Enum.all?(fn {y1, y2} ->
            Enum.all?(0..max_x, fn x -> grid[{x, y1}] == grid[{x, y2}] end)
          end) ->
            y2 * 100

          true ->
            nil
        end
      else
        nil
      end
    end)
  end

  def vertical(grid) do
    max_x = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    Enum.chunk_every(0..max_x, 2, 1, :discard)
    |> Enum.find_value(fn [x1, x2] ->
      if Enum.all?(0..max_y, fn y -> grid[{x1, y}] == grid[{x2, y}] end) do
        cond do
          x2 == 1 || x2 == max_x ->
            x2

          Enum.zip((x1 - 1)..0, (x2 + 1)..max_x)
          |> Enum.all?(fn {x1, x2} ->
            Enum.all?(0..max_y, fn y -> grid[{x1, y}] == grid[{x2, y}] end)
          end) ->
            x2

          true ->
            nil
        end
      else
        nil
      end
    end)
  end

  def horizontal_smudge(grid) do
    max_x = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    Enum.chunk_every(0..max_y, 2, 1, :discard)
    |> Enum.find_value(fn [y1, y2] ->
      case Enum.count(0..max_x, fn x -> grid[{x, y1}] != grid[{x, y2}] end) do
        0 ->
          if Enum.zip((y2 + 1)..max_y, (y1 - 1)..0)
             |> Enum.reduce(0, fn {y1, y2}, acc ->
               Enum.count(0..max_x, fn x -> grid[{x, y1}] != grid[{x, y2}] end) + acc
             end) == 1 do
            y2 * 100
          end

        1 ->
          cond do
            y2 == 1 || y2 == max_y ->
              y2 * 100

            Enum.zip((y2 + 1)..max_y, (y1 - 1)..0)
            |> Enum.all?(fn {y1, y2} ->
              Enum.all?(0..max_x, fn x -> grid[{x, y1}] == grid[{x, y2}] end)
            end) ->
              y2 * 100

            true ->
              nil
          end

        _ ->
          nil
      end
    end)
  end

  def vertical_smudge(grid) do
    max_x = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    Enum.chunk_every(0..max_x, 2, 1, :discard)
    |> Enum.find_value(fn [x1, x2] ->
      case Enum.count(0..max_y, fn y -> grid[{x1, y}] != grid[{x2, y}] end) do
        0 ->
          if Enum.zip((x2 + 1)..max_x, (x1 - 1)..0)
             |> Enum.reduce(0, fn {x1, x2}, acc ->
               Enum.count(0..max_y, fn y -> grid[{x1, y}] != grid[{x2, y}] end) + acc
             end) == 1 do
            x2
          end

        1 ->
          cond do
            x2 == 1 || x2 == max_x ->
              x2

            Enum.zip((x2 + 1)..max_x, (x1 - 1)..0)
            |> Enum.all?(fn {x1, x2} ->
              Enum.all?(0..max_y, fn y -> grid[{x1, y}] == grid[{x2, y}] end)
            end) ->
              x2

            true ->
              nil
          end

        _ ->
          nil
      end
    end)
  end

  def input(filename \\ "day13.txt") do
    File.read!(filename) |> String.split("\n\n") |> Enum.map(&grid/1)
  end

  def grid(list) do
    list
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

Day13.part1() |> IO.inspect()
Day13.part2() |> IO.inspect()
