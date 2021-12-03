# Part 1
File.read!("day3.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.to_charlist/1)
# transpose rows into columns
|> List.zip()
|> Enum.map(&Tuple.to_list/1)
# find the most common occurence for each column
|> Enum.map(&Enum.frequencies/1)
|> Enum.map(fn list -> Enum.sort_by(list, fn {_k, v} -> -v end) end)
|> Enum.map(fn [{gamma, _}, {epsilon, _}] -> [gamma, epsilon] end)
|> List.zip()
|> Enum.map(&Tuple.to_list/1)
|> Enum.map(&List.to_string/1)
|> Enum.map(fn str -> String.to_integer(str, 2) end)
|> Enum.product()
|> IO.inspect()

# Part 2
# This would be nicer if I passed an anonymous function as the rule instead of hard coding it

defmodule Day3 do
  def part2 do
    input = File.read!("day3.txt") |> String.split("\n", trim: true)

    oxygen_generator_rating(input, 0) * co2_scrubber_rating(input, 0)
  end

  def oxygen_generator_rating([rating], _), do: String.to_integer(rating, 2)

  def oxygen_generator_rating(input, position) do
    %{"0" => zero_count, "1" => one_count} =
      Enum.map(input, fn str -> String.at(str, position) end) |> Enum.frequencies()

    new_input =
      if one_count >= zero_count do
        Enum.filter(input, fn str -> String.at(str, position) == "1" end)
      else
        Enum.filter(input, fn str -> String.at(str, position) == "0" end)
      end

    oxygen_generator_rating(new_input, position + 1)
  end

  def co2_scrubber_rating([rating], _), do: String.to_integer(rating, 2)

  def co2_scrubber_rating(input, position) do
    %{"0" => zero_count, "1" => one_count} =
      Enum.map(input, fn str -> String.at(str, position) end) |> Enum.frequencies()

    new_input =
      if zero_count <= one_count do
        Enum.filter(input, fn str -> String.at(str, position) == "0" end)
      else
        Enum.filter(input, fn str -> String.at(str, position) == "1" end)
      end

    co2_scrubber_rating(new_input, position + 1)
  end
end

Day3.part2() |> IO.inspect()
