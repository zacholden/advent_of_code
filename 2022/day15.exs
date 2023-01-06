defmodule Day15 do
  @input File.read!("day15.txt")
         |> String.replace(~r{:|,}, "")
         |> String.split()
         |> Enum.filter(&String.match?(&1, ~r{x|y}))
         |> Enum.chunk_every(4)
         |> Enum.map(fn ["x=" <> x1, "y=" <> y1, "x=" <> x2, "y=" <> y2] ->
           Enum.map([x1, y1, x2, y2], &String.to_integer/1)
         end)

  # Day 2 is probably correct but too slow on the full input.
  # I think this may be an n-queens style problem.
  def part1 do
    closest_beacons = Map.new(@input, fn [sx, sy, bx, by] -> {{sx, sy}, {bx, by}} end)

    distances =
      Map.new(@input, fn [sx, sy, bx, by] ->
        {{sx, sy}, manhatten_distance({sx, sy}, {bx, by})}
      end)

    beacons = Map.values(closest_beacons) |> MapSet.new()

    {min_x, max_x} =
      Enum.flat_map(@input, fn [sx, sy, bx, by] ->
        distance = manhatten_distance({sx, sy}, {bx, by})

        [sx - distance, sx + distance]
      end)
      |> Enum.min_max()

    # y = 10
    y = 2_000_000

    Enum.count(min_x..max_x, fn x ->
      loc = {x, y}

      not Enum.all?(closest_beacons, fn {sensor, _beacon} ->
        distance = Map.fetch!(distances, sensor)

        manhatten_distance(loc, sensor) > distance || loc in beacons
      end)
    end)
  end

  def part2 do
    closest_beacons = Map.new(@input, fn [sx, sy, bx, by] -> {{sx, sy}, {bx, by}} end)

    distances =
      Map.new(@input, fn [sx, sy, bx, by] ->
        {{sx, sy}, manhatten_distance({sx, sy}, {bx, by})}
      end)

    beacons = Map.values(closest_beacons) |> MapSet.new()

    search = for x <- 0..4_000_000, y <- 0..4_000_000, do: {x, y}

    Enum.find(search, fn loc ->
      Enum.all?(closest_beacons, fn {sensor, _beacon} ->
        distance = Map.fetch!(distances, sensor)

        manhatten_distance(loc, sensor) > distance && loc not in beacons
      end)
    end)
  end

  def manhatten_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end

Day15.part1 |> IO.inspect
# Day15.part2() |> IO.inspect()
