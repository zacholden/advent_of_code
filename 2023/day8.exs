defmodule Day8 do
  def part1() do
    {dirs, map} = parse()
    {start, finish} = {"AAA", "ZZZ"}
    state = {0, start}

    Stream.cycle(dirs)
    |> Enum.reduce_while(state, fn dir, {steps, location} ->
      new_location = if dir == "L", do: elem(map[location], 0), else: elem(map[location], 1)
      new_steps = steps + 1
      acc = {new_steps, new_location}

      if new_location == finish, do: {:halt, new_steps}, else: {:cont, acc}
    end)
  end

  def parse do
    [dirs, path] =
      File.read!("day8.txt") |> String.replace(~r{\)|\(|\,}, "") |> String.split("\n\n")

    map =
      String.split(path, "\n", trim: true)
      |> Enum.map(fn str ->
        [a, b] = String.split(str, " = ")
        [a | String.split(b)]
      end)
      |> Map.new(fn [a, b, c] -> {a, {b, c}} end)

    {String.codepoints(dirs), map}
  end
end

Day8.part1() |> IO.inspect()
