defmodule Day1 do
  def part1 do
    File.read!("day1.txt")
    |> String.split()
    |> Enum.map(fn str -> String.replace(str, ~r{[a-z]}, "") end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&Integer.digits/1)
    |> Enum.map(fn list -> [hd(list), List.last(list)] |> Integer.undigits() end)
    |> Enum.sum()
  end

  def part2 do
    File.read!("day1.txt")
    |> String.split()
    |> Enum.map(&extract/1)
    |> Enum.map(fn list -> [hd(list), List.last(list)] |> Integer.undigits() end)
    |> Enum.sum()
  end

  def extract(str), do: extract(str, [])
  def extract("one" <> rest, output), do: extract("ne" <> rest, [1 | output])
  def extract("two" <> rest, output), do: extract("wo" <> rest, [2 | output])
  def extract("three" <> rest, output), do: extract("hree" <> rest, [3 | output])
  def extract("four" <> rest, output), do: extract("our" <> rest, [4 | output])
  def extract("five" <> rest, output), do: extract("ive" <> rest, [5 | output])
  def extract("six" <> rest, output), do: extract("ix" <> rest, [6 | output])
  def extract("seven" <> rest, output), do: extract("even" <> rest, [7 | output])
  def extract("eight" <> rest, output), do: extract("ight" <> rest, [8 | output])
  def extract("nine" <> rest, output), do: extract("ine" <> rest, [9 | output])
  def extract("1" <> rest, output), do: extract(rest, [1 | output])
  def extract("2" <> rest, output), do: extract(rest, [2 | output])
  def extract("3" <> rest, output), do: extract(rest, [3 | output])
  def extract("4" <> rest, output), do: extract(rest, [4 | output])
  def extract("5" <> rest, output), do: extract(rest, [5 | output])
  def extract("6" <> rest, output), do: extract(rest, [6 | output])
  def extract("7" <> rest, output), do: extract(rest, [7 | output])
  def extract("8" <> rest, output), do: extract(rest, [8 | output])
  def extract("9" <> rest, output), do: extract(rest, [9 | output])

  def extract(<<_char::binary-size(1)>> <> rest, output), do: extract(rest, output)

  def extract("", output), do: Enum.reverse(output)
end

Day1.part1() |> IO.inspect()
Day1.part2() |> IO.inspect()
