defmodule Day01 do
  import Integer, only: [mod: 2]
  @size 100

  def part1 do
    input()
    |> Enum.reduce({0, 50}, fn command, {zeros, position} ->
      {_rotations, new_position} = turn(command, position)
      on_zero = if new_position == 0, do: 1, else: 0
      {zeros + on_zero, new_position}
    end)
    |> elem(0)
  end

  def part2 do
    input()
    |> Enum.reduce({0, 50}, fn command, {zeros, position} ->
      {rotations, new_position} = turn(command, position)
      {zeros + rotations, new_position}
    end)
    |> elem(0)
  end

  defp input do
    File.stream!("day01.txt")
    |> Stream.map(fn str -> String.trim(str) |> String.split_at(1) end)
    |> Enum.map(fn {dir, int} -> {dir, String.to_integer(int)} end)
  end

  defp turn({"L", amount}, position) do
    {hundreds, remainder} = divmod(amount, @size)

    new_position = mod(position - remainder, @size)

    hit_zero =
      if position != 0 && (new_position > position || new_position == 0), do: 1, else: 0

    {hundreds + hit_zero, new_position}
  end

  defp turn({"R", amount}, position) do
    {hundreds, remainder} = divmod(amount, @size)

    new_position = mod(position + remainder, @size)

    hit_zero =
      if position != 0 && (new_position < position || new_position == 0), do: 1, else: 0

    {hundreds + hit_zero, new_position}
  end

  def divmod(a, b) do
    {div(a, b), mod(a, b)}
  end
end

Day01.part1() |> IO.puts()
Day01.part2() |> IO.puts()
