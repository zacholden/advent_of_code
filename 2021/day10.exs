defmodule Day10 do
  @input File.stream!("day10.txt") |> Stream.map(&String.trim/1) |> Enum.map(&String.graphemes/1)

  def part1 do
    scores = %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

    Enum.map(@input, fn list -> parse(list) end)
    |> Enum.reduce(0, fn str, acc -> Map.get(scores, str, 0) + acc end)
  end

  def part2 do
    scores = %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

    Enum.map(@input, fn list -> parse(list) end)
    |> Enum.filter(&is_list/1)
    |> Enum.map(fn list ->
      Enum.map(list, fn str -> flip(str) end)
    end)
    |> Enum.map(fn list ->
      Enum.reduce(list, 0, fn str, acc ->
        acc * 5 + scores[str]
      end)
    end)
    |> Enum.sort()
    |> then(fn lists -> Enum.at(lists, div(Enum.count(lists), 2)) end)
  end

  # Return either the list of open delimiters or the invalid delimiter
  defp parse(list) do
    Enum.reduce_while(list, [], fn str, acc ->
      case str do
        ")" ->
          if hd(acc) == "(", do: {:cont, tl(acc)}, else: {:halt, ")"}

        "]" ->
          if hd(acc) == "[", do: {:cont, tl(acc)}, else: {:halt, "]"}

        "}" ->
          if hd(acc) == "{", do: {:cont, tl(acc)}, else: {:halt, "}"}

        ">" ->
          if hd(acc) == "<", do: {:cont, tl(acc)}, else: {:halt, ">"}

        opener ->
          {:cont, [opener | acc]}
      end
    end)
  end

  def flip("("), do: ")"
  def flip("{"), do: "}"
  def flip("["), do: "]"
  def flip("<"), do: ">"
end

Day10.part1() |> IO.inspect()
Day10.part2() |> IO.inspect()
