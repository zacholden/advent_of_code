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
    |> Enum.map(fn str ->
      extract(str)
      |> then(fn numbers -> String.to_integer(String.first(numbers) <> String.last(numbers)) end)
    end)
    |> Enum.sum()
  end

  def extract(<<>>), do: <<>>

  def extract(<<int, rest::binary>>) when int in ?1..?9, do: <<int>> <> extract(rest)

  def extract(<<"one", rest::binary>>), do: "1" <> extract("e" <> rest)
  def extract(<<"two", rest::binary>>), do: "2" <> extract("o" <> rest)
  def extract(<<"three", rest::binary>>), do: "3" <> extract("e" <> rest)
  def extract(<<"four", rest::binary>>), do: "4" <> extract(rest)
  def extract(<<"five", rest::binary>>), do: "5" <> extract("e" <> rest)
  def extract(<<"six", rest::binary>>), do: "6" <> extract(rest)
  def extract(<<"seven", rest::binary>>), do: "7" <> extract("n" <> rest)
  def extract(<<"eight", rest::binary>>), do: "8" <> extract("t" <> rest)
  def extract(<<"nine", rest::binary>>), do: "9" <> extract("e" <> rest)

  def extract(<<_, rest::binary>>), do: extract(rest)
end

Day1.part1() |> IO.inspect()
Day1.part2() |> IO.inspect()
