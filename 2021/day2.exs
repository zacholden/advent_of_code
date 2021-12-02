defmodule Day2 do
  @input File.stream!("day2.txt")
         |> Stream.map(&String.trim/1)
         |> Stream.map(&String.split/1)
         |> Stream.map(&List.to_tuple/1)
         |> Enum.map(fn {dir, amount} -> {dir, String.to_integer(amount)} end)

  def part1 do
    Enum.reduce(@input, {0, 0}, fn {direction, amount}, {horizontal, depth} ->
      case direction do
        "forward" -> {horizontal + amount, depth}
        "up" -> {horizontal, depth - amount}
        "down" -> {horizontal, depth + amount}
      end
    end)
    |> Tuple.to_list()
    |> Enum.product()
  end

  def part2 do
    Enum.reduce(@input, {0, 0, 0}, fn {direction, amount}, {aim, horizontal, depth} ->
      case direction do
        "forward" -> {aim, horizontal + amount, depth + amount * aim}
        "up" -> {aim - amount, horizontal, depth}
        "down" -> {aim + amount, horizontal, depth}
      end
    end)
    |> then(fn {_aim, horizontal, depth} -> horizontal * depth end)
  end
end

Day2.part1() |> IO.inspect()
Day2.part2() |> IO.inspect()
