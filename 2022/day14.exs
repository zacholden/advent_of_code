defmodule Day14 do
  def part1 do
    read_file("day14.txt")
    |> simulate
    |> Enum.count(fn {_k, v} -> v == "o" end)
  end

  # Part 2 takes about 25 miutes to finish. I need to learn how to use
  # Stream.unfold to avoid a ton of non TCO recursion here I think.
  def part2 do
    cave_without_floor = read_file("day14.txt")

    {min_x, max_x} = Enum.map(cave_without_floor, fn {{x, _y}, _} -> x end) |> Enum.min_max()
    max_y = Enum.map(cave_without_floor, fn {{_x, y}, _} -> y end) |> Enum.max()
    floor_y = max_y + 2

    cave =
      Enum.reduce((min_x - 1000)..(max_x + 1000), cave_without_floor, fn x, acc ->
        Map.put(acc, {x, floor_y}, "#")
      end)

    simulate2(cave)
    |> Enum.count(fn {_k, v} -> v == "o" end)
  end

  def simulate2(cave) do
    start = {500, 0}

    new_cave = drop_sand2(cave, start)

    if new_cave[start] == "o" do
      new_cave
    else
      simulate2(new_cave)
    end
  end

  def drop_sand2(cave, start) do
    {start_x, start_y} = start

    landing_spots = Enum.filter(cave, fn {{x, y}, _v} -> start_x == x && start_y < y end)
    {{x, y}, _object} = Enum.min_by(landing_spots, fn {{_x, y}, _v} -> y end)

    cond do
      is_nil(cave[{x - 1, y}]) ->
        drop_sand2(cave, {x - 1, y})

      is_nil(cave[{x + 1, y}]) ->
        drop_sand2(cave, {x + 1, y})

      true ->
        Map.put(cave, {x, y - 1}, "o")
    end
  end

  def simulate(cave) do
    bottom = Map.keys(cave) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    {result, new_cave} = drop_sand(cave, bottom, {500, 0})

    if result == :cont do
      simulate(new_cave)
    else
      new_cave
    end
  end

  def drop_sand(cave, bottom, start) do
    {start_x, start_y} = start

    landing_spots = Enum.filter(cave, fn {{x, y}, _v} -> start_x == x && start_y < y end)

    if start_y < bottom do
      {{x, y}, _object} = Enum.min_by(landing_spots, fn {{_x, y}, _v} -> y end)

      cond do
        is_nil(cave[{x - 1, y}]) ->
          drop_sand(cave, bottom, {x - 1, y})

        is_nil(cave[{x + 1, y}]) ->
          drop_sand(cave, bottom, {x + 1, y})

        true ->
          {:cont, Map.put(cave, {x, y - 1}, "o")}
      end
    else
      {:halt, cave}
    end
  end

  def read_file(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(fn str -> String.split(str, " -> ") end)
    |> Enum.map(fn list ->
      Enum.map(list, fn str ->
        String.split(str, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      end)
    end)
    |> Enum.map(fn list -> Enum.chunk_every(list, 2, 1, :discard) end)
    |> Enum.reduce(%{}, fn list, acc ->
      Enum.reduce(list, acc, fn [{x1, y1}, {x2, y2}], inner_acc ->
        run = for x <- x1..x2, y <- y1..y2, do: {x, y}

        Enum.reduce(run, inner_acc, fn coord, inner_inner_acc ->
          Map.put(inner_inner_acc, coord, "#")
        end)
      end)
    end)
  end

  def draw(grid) do
    {min_x, max_x} = Map.keys(grid) |> Enum.map(fn {x, _y} -> x end) |> Enum.min_max()
    {min_y, max_y} = Map.keys(grid) |> Enum.map(fn {_x, y} -> y end) |> Enum.min_max()

    chunk = Enum.count(min_x..max_x)

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.sort_by(fn {_x, y} -> y end)
    |> Enum.chunk_every(chunk)
    |> Enum.map_join("\n", fn list ->
      Enum.map_join(list, fn coord -> Map.get(grid, coord, ".") end)
    end)
    |> IO.puts()
  end
end

Day14.part1() |> IO.inspect()
Day14.part2() |> IO.inspect()
