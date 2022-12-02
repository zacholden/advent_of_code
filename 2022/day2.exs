defmodule Day2 do
  @input File.read!("day2.txt") |> String.split("\n", trim: true) |> Enum.map(&String.split/1) 
  @scores %{"X" => 1, "Y" => 2, "Z" => 3}

  def part1 do
    Enum.reduce(@input, 0, fn [opponent, us], acc ->
      roll(opponent, us) + acc
    end) 
  end

  def part2 do
    Enum.reduce(@input, 0, fn [opponent, us], acc ->
      strategize(opponent, us) + acc
    end) 
  end

  def roll("A", "X"), do: 3 + @scores["X"]
  def roll("B", "Y"), do: 3 + @scores["Y"]
  def roll("C", "Z"), do: 3 + @scores["Z"]
  def roll("A", "Y"), do: 6 + @scores["Y"]
  def roll("B", "Z"), do: 6 + @scores["Z"]
  def roll("C", "X"), do: 6 + @scores["X"]
  def roll(_a, b), do: @scores[b]

  def strategize("A", "X"), do: roll("A", "Z")
  def strategize("A", "Y"), do: roll("A", "X")
  def strategize("A", "Z"), do: roll("A", "Y")
  def strategize("B", "X"), do: roll("B", "X")
  def strategize("B", "Y"), do: roll("B", "Y")
  def strategize("B", "Z"), do: roll("B", "Z")
  def strategize("C", "X"), do: roll("C", "Y")
  def strategize("C", "Y"), do: roll("C", "Z")
  def strategize("C", "Z"), do: roll("C", "X")
end

Day2.part1 |> IO.inspect
Day2.part2 |> IO.inspect
