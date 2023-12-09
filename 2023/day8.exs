defmodule Day8 do
  def part1 do
    {dirs, map} = parse()
    start = "AAA"
    finish = MapSet.new(["ZZZ"])

    search(dirs, map, start, finish)
  end

  def part2 do
    {dirs, map} = parse()
    starting = Map.keys(map) |> Enum.filter(&String.ends_with?(&1, "A"))
    finishing = Map.keys(map) |> Enum.filter(&String.ends_with?(&1, "Z")) |> MapSet.new()

    Enum.map(starting, fn start -> search(dirs, map, start, finishing) end)
    |> Enum.reduce(1, fn steps, lcd ->
      div(steps * lcd, Integer.gcd(steps, lcd))
    end)
  end

  def search(dirs, map, start, finish) do
    Stream.cycle(dirs)
    |> Enum.reduce_while({0, start}, fn dir, {steps, location} ->
      new_location = if dir == "L", do: elem(map[location], 0), else: elem(map[location], 1)
      new_steps = steps + 1
      acc = {new_steps, new_location}

      if MapSet.member?(finish, new_location), do: {:halt, new_steps}, else: {:cont, acc}
    end)
  end

  def parse do
    [dirs, path] =
      File.read!("day8.txt") |> String.split("\n\n")

    map =
      String.split(path, "\n", trim: true)
      |> Enum.map(fn str -> String.replace(str, [" =", "(", ")", ","], "") |> String.split() end)
      |> Map.new(fn [a, b, c] -> {a, {b, c}} end)

    {String.codepoints(dirs), map}
  end
end

Day8.part1() |> IO.inspect()
Day8.part2() |> IO.inspect()
