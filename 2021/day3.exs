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

defmodule Day3 do
  def part2 do
    input = File.read!("day3.txt") |> String.split("\n", trim: true)

    oxygen_rating_rule = fn a, b -> if a <= b, do: "1", else: "0" end
    co2_rating_rule = fn a, b -> if a <= b, do: "0", else: "1" end

    find_rating(input, oxygen_rating_rule, 0) * find_rating(input, co2_rating_rule, 0)
  end

  def find_rating([rating], _, _), do: String.to_integer(rating, 2)

  def find_rating(input, rule, position) do
    %{"0" => zero_count, "1" => one_count} =
      Enum.map(input, fn str -> String.at(str, position) end) |> Enum.frequencies()

    one_or_zero = rule.(zero_count, one_count)

    new_input = Enum.filter(input, fn str -> String.at(str, position) == one_or_zero end)

    find_rating(new_input, rule, position + 1)
  end
end

Day3.part2() |> IO.inspect()
