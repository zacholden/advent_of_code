defmodule Day14 do
  @sand "o"
  @rock "#"
  @cave File.read!("day14.txt")
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
              Map.put(inner_inner_acc, coord, @rock)
            end)
          end)
        end)

  # Part 2 takes about 25 miutes to finish. I need to learn how to use
  # Stream.unfold to avoid a ton of non TCO recursion here I think.
  #
  # Update from the future I think the actual problem was all of the
  # filtering on big map it runs in under a second now.
  #
  # I think I understand Stream.unfold better now but part 1 is missing
  # one graind of sand when I draw it. Returing {acc, nil} works for part 2
  # but not part 1 and I can't figure out why.

  def part1 do
    bottom = Map.keys(@cave) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    Stream.unfold(@cave, fn cave -> drop_sand(cave, bottom, {500, 0}) end)
  end

  def part2 do
    cave_without_floor = @cave

    floor =
      Map.keys(cave_without_floor) |> Enum.map(fn {_x, y} -> y end) |> Enum.max() |> Kernel.+(2)

    middle = 500
    floor_width = Enum.reduce(0..floor, 1, fn _y, acc -> acc + 2 end) |> div(2)

    cave =
      Enum.reduce((middle - floor_width)..(middle + floor_width), cave_without_floor, fn x, acc ->
        Map.put(acc, {x, floor}, @rock)
      end)

    Stream.unfold(cave, fn cave -> drop_sand(cave, floor, {500, 0}) end)
  end

  def drop_sand(cave, bottom, location = {x, y}) do
    if cave[{500, 0}] == @sand do
      {cave, nil}
    else
      space = Enum.find([{x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1}], &(!cave[&1]))

      case space do
        nil -> {cave, Map.put(cave, location, @sand)}
        {_, y} when y > bottom -> nil
        _ -> drop_sand(cave, bottom, space)
      end
    end
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

# Answers

Day14.part1() |> Enum.count() |> IO.inspect()
Day14.part2() |> Enum.count() |> IO.inspect()

# Drawings

# Day14.part1() |> Enum.reduce(&Map.merge/2) |> Day14.draw()
# Day14.part2() |> Enum.reduce(&Map.merge/2) |> Day14.draw()
